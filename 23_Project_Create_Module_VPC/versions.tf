# =============================================================================
# TERRAFORM AND PROVIDER CONFIGURATION
# =============================================================================
# This file defines the Terraform version requirements and provider configurations
# for the VPC Module project. It establishes the foundation for all AWS resource
# management and ensures consistent behavior across different environments.

# Terraform configuration block
# Defines the required providers and their version constraints
# This ensures reproducible deployments and prevents compatibility issues
terraform {
  # Required providers configuration
  # Specifies which providers this configuration depends on
  required_providers {
    # AWS Provider for managing AWS resources
    aws = {
      # Official HashiCorp AWS provider from the Terraform Registry
      # This is the authoritative source for AWS resource management
      source = "hashicorp/aws"
      
      # Version constraint using pessimistic operator
      # ~> 6.0 means >= 6.0.0 and < 7.0.0
      # This allows patch and minor updates while preventing breaking changes
      # Version 6.x includes enhanced VPC features and improved resource management
      version = "~> 6.0"
    }
  }
}

# AWS Provider configuration
# Configures the AWS provider with default settings for all AWS resources
# This provider configuration will be inherited by the network module
provider "aws" {
  # Default AWS region for all resources
  # us-west-1 (Northern California) provides:
  # - Lower latency for West Coast users
  # - Compliance with data residency requirements
  # - Cost optimization for regional deployments
  # - Multiple availability zones for high availability
  region = "us-west-1"
  
  # Additional provider configurations can be added here:
  # - default_tags: Apply tags to all resources automatically
  # - assume_role: Use cross-account access
  # - profile: Use specific AWS CLI profile
  # - shared_credentials_file: Custom credentials file location
}