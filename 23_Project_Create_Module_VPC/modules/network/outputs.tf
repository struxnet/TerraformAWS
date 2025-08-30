# =============================================================================
# NETWORK MODULE OUTPUTS
# =============================================================================
# This file defines the outputs from the network module, providing essential
# network information to consuming modules and configurations. The outputs
# are structured to provide comprehensive subnet and VPC details for
# downstream resource deployment and configuration.

# Local values for output data transformation
# These locals process the created subnets into structured output formats
# that are easy to consume by other Terraform configurations
locals {
  # Transform public subnets into a structured output format
  # Creates a map with subnet keys pointing to essential subnet information
  # This structure enables easy consumption by resources that need public subnet details
  output_public_subnets = {
    for key in keys(local.public_subnets) : key => {
      # AWS subnet resource ID for referencing in other resources
      # Essential for deploying resources into specific subnets
      subnet_id = aws_subnet.this[key].id
      
      # Availability zone information for the subnet
      # Useful for multi-AZ deployments and availability planning
      availability_zones = aws_subnet.this[key].availability_zone
    }
  }
  
  # Transform private subnets into a structured output format
  # Creates a map with subnet keys pointing to essential subnet information
  # This structure enables easy consumption by resources that need private subnet details
  output_private_subnets = {
    for key in keys(local.private_subnets) : key => {
      # AWS subnet resource ID for referencing in other resources
      # Essential for deploying resources into specific subnets
      subnet_id = aws_subnet.this[key].id
      
      # Availability zone information for the subnet
      # Useful for multi-AZ deployments and availability planning
      availability_zones = aws_subnet.this[key].availability_zone
    }
  }
}

# VPC ID output
# Provides the unique identifier of the created VPC
# This is the most fundamental output needed by other resources
output "vpc_id" {
  description = "The ID of the VPC created by this module"
  value       = aws_vpc.this.id
  
  # This output is essential for:
  # - Creating security groups within the VPC
  # - Configuring VPC peering connections
  # - Setting up VPC endpoints
  # - Referencing the VPC in other Terraform configurations
}

# Public subnets output
# Provides detailed information about all public subnets created by the module
# Returns a map structure for easy consumption by other resources
output "public_subnets" {
  description = "Map of public subnets with their IDs and availability zones"
  value       = local.output_public_subnets
  
  # This output is useful for:
  # - Deploying internet-facing load balancers
  # - Creating NAT gateways for private subnet internet access
  # - Placing bastion hosts or jump servers
  # - Configuring auto-scaling groups that need internet connectivity
  # 
  # Output structure:
  # {
  #   "subnet_key" = {
  #     subnet_id = "subnet-12345678"
  #     availability_zones = "us-west-1a"
  #   }
  # }
}

# Private subnets output
# Provides detailed information about all private subnets created by the module
# Returns a map structure for easy consumption by other resources
output "private_subnets" {
  description = "Map of private subnets with their IDs and availability zones"
  value       = local.output_private_subnets
  
  # This output is useful for:
  # - Deploying application servers and databases
  # - Creating internal load balancers
  # - Placing backend services that don't need direct internet access
  # - Configuring auto-scaling groups for internal applications
  # 
  # Output structure:
  # {
  #   "subnet_key" = {
  #     subnet_id = "subnet-87654321"
  #     availability_zones = "us-west-1b"
  #   }
  # }
}