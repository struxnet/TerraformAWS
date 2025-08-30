# =============================================================================
# NETWORK MODULE - TERRAFORM AND PROVIDER CONFIGURATION
# =============================================================================
# This file defines the Terraform version requirements and provider configurations
# specifically for the network module. It ensures compatibility and establishes
# the foundation for AWS resource management within the module scope.

# Terraform configuration block for the network module
# Defines the required providers and their version constraints
# This ensures the module works consistently across different environments
terraform {
  # Required providers configuration
  # Specifies which providers this module depends on and their version constraints
  required_providers {
    # AWS Provider for managing AWS networking resources
    aws = {
      # Official HashiCorp AWS provider from the Terraform Registry
      # This is the authoritative source for AWS resource management
      source = "hashicorp/aws"
      
      # Version constraint using pessimistic operator
      # ~> 6.0 means >= 6.0.0 and < 7.0.0
      # This allows patch and minor updates while preventing breaking changes
      # Version 6.x includes:
      # - Enhanced VPC and subnet management features
      # - Improved error handling and validation
      # - Better support for advanced networking configurations
      # - Optimized resource creation and updates
      version = "~> 6.0"
    }
  }
  
  # Note: This module inherits the provider configuration from the root module
  # No explicit provider block is needed here as it will use the provider
  # configuration defined in the calling module or root configuration
  
  # Module-specific considerations:
  # - This module is designed to be region-agnostic
  # - It will use whatever region is configured in the calling module
  # - All networking resources will be created in the provider's configured region
}