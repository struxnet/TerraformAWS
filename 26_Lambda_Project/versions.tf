# =============================================================================
# TERRAFORM AND PROVIDER CONFIGURATION
# =============================================================================
# This file defines the Terraform version requirements and provider configurations
# for the Lambda project. It establishes the foundation for AWS resource management
# and ensures consistent behavior across different environments.

# Terraform configuration block
# Defines required providers, their versions, and Terraform version constraints
terraform {
  # Required providers configuration
  # Specifies which providers this configuration depends on
  required_providers {
    # AWS Provider for managing AWS Lambda and related services
    aws = {
      # Official HashiCorp AWS provider from the Terraform Registry
      source = "hashicorp/aws"

      # Version constraint using pessimistic operator
      # ~> 6.0 means >= 6.0.0 and < 7.0.0
      # This allows patch and minor updates while preventing breaking changes
      # Version 6.x includes enhanced Lambda features and improved resource management
      version = "~> 6.0"
    }

    # Archive Provider for creating ZIP files and other archives
    archive = {
      # Official HashiCorp Archive provider
      # Used for packaging Lambda function code into deployment archives
      source = "hashicorp/archive"

      # Version constraint for Archive provider
      # ~> 2.0 means >= 2.0.0 and < 3.0.0
      # Provides stable archive creation and management functionality
      version = "~> 2.0"
    }
  }

  # Minimum Terraform version required for this configuration
  # Version 1.0+ includes important features for provider management
  # and improved state handling
  required_version = ">= 1.0"
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

  # Default tags applied to all resources created by this provider
  # These tags are automatically applied to all supported AWS resources
  # Provides consistent tagging for cost tracking and resource management
  default_tags {
    tags = {
      # Indicates that resources are managed by Terraform
      # Helps operations teams understand resource lifecycle management
      ManagedBy = "Terraform"

      # Project identifier for grouping related resources
      # Useful for cost allocation and resource organization
      # This project demonstrates importing existing Lambda functions into Terraform
      Project = "Project 3 Import Lambda Function"
    }
  }

  # Additional provider configurations that can be added:
  # profile                     = "default"           # AWS CLI profile to use
  # shared_credentials_files    = ["~/.aws/credentials"] # Custom credentials file
  # assume_role { ... }                               # Cross-account role assumption
  # endpoints { ... }                                 # Custom service endpoints
}