# =============================================================================
# TERRAFORM AND PROVIDER CONFIGURATION
# =============================================================================
# This file defines the Terraform version requirements and provider configurations
# for the IAM Role Management project. Version constraints ensure compatibility
# and reproducible deployments across different environments.

# Terraform configuration block
# Specifies the minimum Terraform version and required providers
terraform {
  # Terraform version constraint using pessimistic operator
  # ~> 1.8 means >= 1.8.0 and < 1.9.0
  # This ensures compatibility with Terraform 1.8.x releases while preventing
  # potential breaking changes in major version updates
  required_version = "~> 1.8"
  
  # Define required providers and their version constraints
  # This ensures consistent provider versions across team members and environments
  required_providers {
    # AWS Provider for managing AWS IAM resources
    aws = {
      # Official HashiCorp AWS provider from Terraform Registry
      source = "hashicorp/aws"
      
      # Version constraint using pessimistic operator
      # ~> 6.0 means >= 6.0.0 and < 7.0.0
      # This allows patch and minor updates while preventing breaking changes
      # Version 6.x includes enhanced IAM features and improved error handling
      version = "~> 6.0"
    }
  }
}

# AWS Provider configuration
# Configures the AWS provider with default settings for all AWS resources
provider "aws" {
  # Default AWS region for all IAM resources
  # IAM is a global service, but some operations require a region specification
  # us-west-1 (Northern California) is used as the default region
  region = "us-west-1"
  
  # Additional provider configurations can be added here:
  # - default_tags: Apply tags to all resources automatically
  # - assume_role: Use cross-account access for role management
  # - profile: Use specific AWS CLI profile for authentication
}