locals {
  project_name = "Modules"
  common_tags = {
    Project   = local.project_name
    ManagedBy = "Terraform"
  }
}