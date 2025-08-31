# =============================================================================
# RDS MODULE - TERRAFORM AND PROVIDER CONFIGURATION
# =============================================================================
# This file defines the Terraform version requirements and provider configurations
# specifically for the RDS module. It ensures compatibility and establishes
# the foundation for AWS RDS resource management within the module scope.

# Terraform configuration block for the RDS module
# Defines the required providers and their version constraints
terraform {
  # Required providers configuration
  # Specifies which providers this module depends on
  required_providers {
    # AWS Provider for managing RDS and related AWS resources
    aws = {
      # Official HashiCorp AWS provider from the Terraform Registry
      # This is the authoritative source for AWS resource management
      source = "hashicorp/aws"
      
      # Version constraint using pessimistic operator
      # ~> 6.0 means >= 6.0.0 and < 7.0.0
      # This allows patch and minor updates while preventing breaking changes
      # Version 6.x includes:
      # - Enhanced RDS instance management features
      # - Improved security group validation
      # - Better support for advanced RDS configurations
      # - Optimized resource creation and lifecycle management
      version = "~> 6.0"
    }
  }
  
  # Note: This module inherits the provider configuration from the root module
  # No explicit provider block is needed here as it will use the provider
  # configuration defined in the calling module or root configuration
  
  # Module-specific considerations:
  # - This module is designed to be region-agnostic
  # - It will use whatever region is configured in the calling module
  # - All RDS resources will be created in the provider's configured region
  # - The module supports multi-AZ deployments within the configured region
}