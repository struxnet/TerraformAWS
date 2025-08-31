# =============================================================================
# TERRAFORM AND PROVIDER CONFIGURATION
# =============================================================================
# This file defines the Terraform version requirements and provider configurations
# for the RDS project. It establishes the foundation for AWS RDS and networking
# resource management with proper version constraints.

# Terraform configuration block
# Defines required Terraform version and provider dependencies
terraform {
  # Terraform version constraint
  # ~> 1.0 means >= 1.0.0 and < 2.0.0
  # Ensures compatibility with Terraform 1.x features including advanced validation
  required_version = "~> 1.0"
  
  # Required providers for RDS project
  required_providers {
    # AWS Provider for managing RDS and networking resources
    aws = {
      # Official HashiCorp AWS provider
      source = "hashicorp/aws"
      
      # Version constraint for AWS provider
      # ~> 6.0 means >= 6.0.0 and < 7.0.0
      # Version 6.x includes enhanced RDS features and improved validation
      version = "~> 6.0"
    }
  }
}

# AWS Provider configuration
# Configures the AWS provider with regional settings for RDS deployment
provider "aws" {
  # AWS region for RDS deployment
  # us-west-1 (Northern California) provides:
  # - Multiple availability zones for RDS multi-AZ deployment
  # - Cost-effective RDS instance pricing
  # - Low latency for West Coast applications
  region = "us-west-1"
}