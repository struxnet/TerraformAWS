# =============================================================================
# TERRAFORM AND PROVIDER CONFIGURATION
# =============================================================================
# This file defines the Terraform version requirements and provider configurations.
# Version constraints ensure compatibility and reproducible deployments across
# different environments and team members.

# Terraform configuration block
# Specifies the minimum Terraform version and required providers
terraform {
  # Minimum Terraform version required for this configuration
  # Version 1.9.0+ includes important features and bug fixes
  # Using >= ensures compatibility with newer versions
  required_version = ">= 1.9.0"
  
  # Define required providers and their version constraints
  # This ensures all team members use compatible provider versions
  required_providers {
    # AWS Provider for managing AWS resources
    aws = {
      # Official HashiCorp AWS provider from Terraform Registry
      source = "hashicorp/aws"
      
      # Version constraint using pessimistic operator (~>)
      # ~> 6.0 means >= 6.0.0 and < 7.0.0
      # This allows patch and minor updates while preventing breaking changes
      version = "~> 6.0"
    }
    
    # TLS Provider for cryptographic operations
    tls = {
      # Official HashiCorp TLS provider for generating keys and certificates
      source = "hashicorp/tls"
      
      # Version constraint for TLS provider
      # ~> 4.0 means >= 4.0.0 and < 5.0.0
      # Provides stability while allowing compatible updates
      version = "~> 4.0"
    }
  }
}

# AWS Provider configuration
# Configures the AWS provider with default settings for all AWS resources
provider "aws" {
  # Default AWS region for all resources
  # us-west-1 (Northern California) provides:
  # - Lower latency for West Coast users
  # - Compliance with data residency requirements
  # - Cost optimization for regional deployments
  region = "us-west-1"
  
  # Additional provider configurations can be added here:
  # - default_tags: Apply tags to all resources automatically
  # - assume_role: Use cross-account access
  # - profile: Use specific AWS CLI profile
  # - access_key/secret_key: Explicit credentials (not recommended)
}