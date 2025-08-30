# =============================================================================
# ROOT MODULE OUTPUTS
# =============================================================================
# This file exposes the network module outputs at the root level,
# making them available for consumption by other Terraform configurations
# or for display to users. These outputs provide essential network
# information needed for deploying additional resources.

# Public subnets information from the network module
# Exposes all public subnets with their IDs and availability zones
# This output is useful for:
# - Deploying internet-facing resources (load balancers, NAT gateways)
# - Creating auto-scaling groups that span multiple public subnets
# - Configuring resources that need direct internet connectivity
output "module_public_subnets" {
  description = "Map of public subnets with their IDs and availability zones from the network module"
  value       = module.networks.public_subnets
}

# Private subnets information from the network module
# Exposes all private subnets with their IDs and availability zones
# This output is useful for:
# - Deploying internal resources (databases, application servers)
# - Creating auto-scaling groups for backend services
# - Configuring resources that should not have direct internet access
output "module_private_subnets" {
  description = "Map of private subnets with their IDs and availability zones from the network module"
  value       = module.networks.private_subnets
}

# VPC ID from the network module
# Exposes the VPC identifier for use in other configurations
# This output is essential for:
# - Creating security groups within the VPC
# - Configuring VPC peering connections
# - Setting up VPC endpoints and other VPC-scoped resources
# - Referencing the VPC in other Terraform configurations
output "module_vpc_id" {
  description = "The ID of the VPC created by the network module"
  value       = module.networks.vpc_id
}