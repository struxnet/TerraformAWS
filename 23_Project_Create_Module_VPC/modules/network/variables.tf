# =============================================================================
# NETWORK MODULE INPUT VARIABLES
# =============================================================================
# This file defines the input variables for the network module, providing
# a flexible and validated interface for VPC and subnet configuration.
# The variables use advanced Terraform features including object types,
# optional attributes, and comprehensive validation rules.

# VPC configuration variable
# Defines the overall VPC settings including naming and IP address space
# This object-type variable ensures all required VPC parameters are provided
variable "vpc_config" {
  description = "Configuration object for VPC creation including name and CIDR block"
  
  # Object type definition with required attributes
  # This structure ensures consistent VPC configuration across deployments
  type = object({
    # Human-readable name for the VPC
    # Used for resource identification in AWS console and automation
    name = string
    
    # CIDR block defining the IP address range for the VPC
    # Must be a valid CIDR notation (e.g., "10.0.0.0/16")
    # Determines the total number of IP addresses available in the VPC
    cidr_block = string
  })
  
  # Validation rule to ensure CIDR block is properly formatted
  # Uses Terraform's built-in cidrnetmask function to validate CIDR syntax
  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "The vpc_cidr must be a valid CIDR block (e.g., '10.0.0.0/16')."
  }
}

# Subnet configuration variable
# Defines multiple subnets with their individual settings
# Uses a map structure to allow flexible subnet definitions
variable "subnet_config" {
  description = "Map of subnet configurations with CIDR blocks, names, availability zones, and public/private designation"
  
  # Map of objects allowing multiple subnet definitions
  # Each key represents a unique subnet identifier
  # Each value contains the subnet's configuration parameters
  type = map(object({
    # CIDR block for the individual subnet
    # Must be a subset of the VPC CIDR block
    # Determines the number of IP addresses available in this subnet
    cidr_block = string
    
    # Human-readable name for the subnet
    # Used for resource identification and tagging
    name = string
    
    # Availability Zone where the subnet will be created
    # Must be a valid AZ in the current AWS region
    # Enables multi-AZ deployments for high availability
    azs = string
    
    # Optional flag to designate subnet as public or private
    # public = true: Subnet will have internet gateway access
    # public = false (default): Subnet will be private without direct internet access
    # The optional() function provides a default value of false
    public = optional(bool, false)
  }))
  
  # Validation rule to ensure all subnet CIDR blocks are properly formatted
  # Uses alltrue() to validate every subnet configuration in the map
  validation {
    condition = alltrue([
      for subnet_config in values(var.subnet_config) : can(cidrnetmask(subnet_config.cidr_block))
    ])
    error_message = "All subnet CIDR blocks must be valid CIDR notation (e.g., '10.0.1.0/24')."
  }
  
  # Example usage:
  # subnet_config = {
  #   web_subnet = {
  #     cidr_block = "10.0.1.0/24"
  #     name       = "Web Tier Subnet"
  #     azs        = "us-west-1a"
  #     public     = true
  #   }
  #   app_subnet = {
  #     cidr_block = "10.0.2.0/24"
  #     name       = "Application Tier Subnet"
  #     azs        = "us-west-1b"
  #     public     = false
  #   }
  # }
}