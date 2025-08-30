# =============================================================================
# VPC NETWORK MODULE - CORE INFRASTRUCTURE
# =============================================================================
# This module creates a complete VPC network infrastructure with support for
# both public and private subnets, internet connectivity, and proper routing.
# It demonstrates advanced Terraform patterns including dynamic resource creation,
# conditional logic, and comprehensive validation.

# Local values for subnet categorization
# These locals separate public and private subnets for different processing
# This pattern enables conditional resource creation and targeted operations
locals {
  # Filter and extract public subnets from the input configuration
  # Public subnets will have internet gateway access and public IP assignment
  # This map contains only subnets where public = true
  public_subnets = {
    for key, subnet_config in var.subnet_config : key => subnet_config
    if subnet_config.public
  }

  # Filter and extract private subnets from the input configuration
  # Private subnets will not have direct internet access
  # This map contains subnets where public = false (default) or explicitly false
  private_subnets = {
    for key, subnet_config in var.subnet_config : key => subnet_config
    if !subnet_config.public
  }
}

# Data source to fetch available availability zones in the current region
# This ensures we only use valid AZs and provides validation for subnet placement
# The state filter ensures we only get currently available zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Create the Virtual Private Cloud (VPC)
# The VPC provides an isolated network environment for all resources
# It serves as the foundation for all networking components
resource "aws_vpc" "this" {
  # Use the CIDR block from the input variable
  # This defines the IP address range for the entire VPC
  cidr_block = var.vpc_config.cidr_block
  
  # Apply naming tag for resource identification
  # Tags are essential for resource management and cost tracking
  tags = {
    Name = var.vpc_config.name
  }
}

# Create subnets based on the input configuration
# This resource uses for_each to create multiple subnets dynamically
# Each subnet can be configured as public or private
resource "aws_subnet" "this" {
  # Create one subnet for each entry in the subnet_config variable
  # This enables flexible subnet creation based on input requirements
  for_each = var.subnet_config
  
  # Associate each subnet with the VPC
  vpc_id = aws_vpc.this.id
  
  # Set the CIDR block for this specific subnet
  # Must be a subset of the VPC CIDR block
  cidr_block = each.value.cidr_block
  
  # Place the subnet in the specified availability zone
  # This enables multi-AZ deployments for high availability
  availability_zone = each.value.azs

  # Apply descriptive tags for resource identification
  # The Access tag helps distinguish between public and private subnets
  tags = {
    Name   = each.key  # Use the subnet key as the name
    Access = each.value.public ? "Public" : "Private"  # Indicate subnet type
  }

  # Lifecycle management with precondition validation
  # This ensures the specified availability zone is valid before creation
  lifecycle {
    # Validate that the specified AZ exists in the current region
    # This prevents deployment failures due to invalid AZ specifications
    precondition {
      condition = contains(data.aws_availability_zones.available.names, each.value.azs)
      
      # Comprehensive error message with debugging information
      # Provides clear guidance for resolving AZ validation failures
      error_message = <<-EOT
        Subnet Key: ${each.key}
        AWS Region: ${data.aws_availability_zones.available.id}
        Invalid AZ: ${each.value.azs}
        List of Supported AZs: [${join(", ", data.aws_availability_zones.available.names)}]
        
        The availability zone "${each.value.azs}" is not available in the current region.
        Please use one of the supported availability zones listed above.
        
        Common causes:
        - Typo in availability zone name
        - AZ not available in the selected region
        - AZ temporarily unavailable
      EOT
    }
  }
}

# Create Internet Gateway for public subnet connectivity
# Only created if there are public subnets defined
# This conditional creation optimizes resource usage
resource "aws_internet_gateway" "this" {
  # Conditional creation: only create if public subnets exist
  # This prevents unnecessary resource creation when only private subnets are used
  count = length(keys(local.public_subnets)) > 0 ? 1 : 0
  
  # Attach the Internet Gateway to the VPC
  # This enables internet connectivity for the VPC
  vpc_id = aws_vpc.this.id
}

# Create route table for public subnets
# Routes internet traffic (0.0.0.0/0) to the Internet Gateway
# Only created if public subnets exist
resource "aws_route_table" "public_rtb" {
  # Conditional creation: only create if public subnets exist
  # This ensures we don't create unnecessary routing infrastructure
  count = length(keys(local.public_subnets)) > 0 ? 1 : 0
  
  # Associate the route table with the VPC
  vpc_id = aws_vpc.this.id
  
  # Define the default route for internet traffic
  # This route directs all traffic (0.0.0.0/0) to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"  # All traffic (default route)
    gateway_id = aws_internet_gateway.this[0].id  # Route to Internet Gateway
  }
}

# Associate public subnets with the public route table
# This enables internet connectivity for resources in public subnets
# Only processes subnets marked as public
resource "aws_route_table_association" "public" {
  # Create associations only for public subnets
  # This ensures private subnets don't get internet connectivity
  for_each = local.public_subnets
  
  # Associate the specific subnet with the public route table
  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public_rtb[0].id
}