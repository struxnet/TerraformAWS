# =============================================================================
# LOCAL VALUES
# =============================================================================
# Local values allow you to define reusable expressions and constants
# that can be referenced throughout your Terraform configuration.
# This promotes consistency and makes maintenance easier.

# Define common tags that will be applied to all resources
# Consistent tagging is crucial for:
# - Cost tracking and allocation
# - Resource organization and filtering
# - Compliance and governance
# - Automation and lifecycle management
locals {
  common_tags = {
    # Indicates that this resource is managed by Terraform
    # Helps operations teams understand how the resource was created
    ManagedBy = "Terraform"
    
    # Project identifier for grouping related resources
    # Useful for cost allocation and resource organization
    Project = "06_VPC_EC2"
    
    # Environment designation (Production, Staging, Development, etc.)
    # Critical for applying appropriate policies and access controls
    Env = "Production"
  }
}