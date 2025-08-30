# =============================================================================
# NETWORK MODULE CONFIGURATION
# =============================================================================
# This file configures the custom network module to create a complete
# VPC infrastructure with both public and private subnets across multiple
# availability zones. This demonstrates modular infrastructure design
# and reusable network components.

# Network module instantiation with comprehensive VPC and subnet configuration
# This module creates a complete network infrastructure including:
# - VPC with custom CIDR block
# - Multiple subnets (public and private)
# - Internet Gateway for public subnet connectivity
# - Route tables and associations for proper traffic routing
module "networks" {
  # Source path to the local network module
  # Using a relative path allows for easy module development and testing
  # before publishing to a module registry
  source = "./modules/network"
  
  # VPC configuration object
  # Defines the overall network container with its IP address space
  vpc_config = {
    # CIDR block for the entire VPC
    # 10.0.0.0/16 provides 65,536 IP addresses (10.0.0.0 - 10.0.255.255)
    # This is part of the RFC 1918 private address space, safe for internal use
    cidr_block = "10.0.0.0/16"
    
    # Human-readable name for the VPC
    # Used for AWS console display and resource identification
    name = "Own_VPC_From_Module"
  }
  
  # Subnet configuration map
  # Each key represents a unique subnet with its specific configuration
  # This flexible structure allows for easy addition/removal of subnets
  subnet_config = {
    # Private subnet for internal resources (databases, application servers)
    # Resources in this subnet cannot be directly accessed from the internet
    subnet_1 = {
      # CIDR block for this subnet
      # 10.0.1.0/24 provides 256 IP addresses (10.0.1.0 - 10.0.1.255)
      cidr_block = "10.0.1.0/24"
      
      # Descriptive name for the subnet
      name = "Own_Subnet_1_From_Module"
      
      # Availability Zone placement
      # us-west-1b provides geographic distribution for high availability
      azs = "us-west-1b"
      
      # public = false (default) - This creates a private subnet
      # Private subnets do not have direct internet connectivity
    }
    
    # Public subnet for internet-facing resources (load balancers, NAT gateways)
    # Resources in this subnet can be directly accessed from the internet
    subnet_2 = {
      # CIDR block for this subnet
      # 10.0.2.0/24 provides 256 IP addresses (10.0.2.0 - 10.0.2.255)
      cidr_block = "10.0.2.0/24"
      
      # Descriptive name for the subnet
      name = "Own_Subnet_2_From_Module"
      
      # Mark as public subnet
      # This enables internet gateway routing and public IP assignment
      public = true
      
      # Availability Zone placement
      # us-west-1c provides geographic separation from subnet_1
      azs = "us-west-1c"
    }
    
    # Additional public subnet for multi-AZ deployment patterns
    # Having multiple public subnets enables high availability architectures
    # Note: This overwrites the previous subnet_2 due to duplicate key
    # TODO: Fix duplicate key - should be subnet_3
    subnet_3 = {
      # CIDR block for this subnet
      # 10.0.3.0/24 provides 256 IP addresses (10.0.3.0 - 10.0.3.255)
      cidr_block = "10.0.3.0/24"
      
      # Descriptive name for the subnet
      name = "Own_Subnet_3_From_Module"
      
      # Mark as public subnet
      # Enables internet connectivity for resources in this subnet
      public = true
      
      # Availability Zone placement
      # us-west-1b provides redundancy with subnet_1 in the same AZ
      azs = "us-west-1b"
    }
  }
}