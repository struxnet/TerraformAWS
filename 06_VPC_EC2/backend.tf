# =============================================================================
# TERRAFORM BACKEND CONFIGURATION
# =============================================================================
# This file configures the Terraform backend to store state remotely in AWS S3
# Remote state storage provides several benefits:
# - State sharing between team members
# - State locking to prevent concurrent modifications
# - State versioning and backup
# - Enhanced security with encryption

terraform {
  # Configure S3 backend for remote state storage
  backend "s3" {
    # S3 bucket name where the Terraform state file will be stored
    # This bucket must exist before running terraform init
    bucket = "shah-terraform-state-bucket-aws"
    
    # Path within the bucket where this project's state file will be stored
    # Using a descriptive path helps organize multiple projects
    key = "06-backends/state.tfstate"
    
    # AWS region where the S3 bucket is located
    region = "us-west-1"
    
    # Enable state locking using DynamoDB to prevent concurrent modifications
    # This prevents multiple users from applying changes simultaneously
    use_lockfile = true
    
    # Enable server-side encryption for the state file
    # This ensures sensitive data in the state is encrypted at rest
    encrypt = true
  }
}