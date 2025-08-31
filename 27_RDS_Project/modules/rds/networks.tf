# =============================================================================
# RDS MODULE - NETWORK AND SECURITY VALIDATION
# =============================================================================
# This file implements comprehensive validation for network and security
# configurations to ensure RDS instances are deployed following security
# best practices. It validates subnet placement and security group rules.

# =============================================================================
# SUBNET VALIDATION
# =============================================================================

# Data source to identify the default VPC
# Used for validation to prevent RDS deployment in default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source to validate each subnet provided for RDS deployment
# Implements comprehensive checks for subnet compliance
data "aws_subnet" "from_subnet_ids" {
  # Create a data source for each subnet ID provided
  for_each = toset(var.subnet_ids)
  id       = each.value

  # Lifecycle management with postcondition validation
  # Ensures subnets meet security and compliance requirements
  lifecycle {
    # Validation 1: Prevent deployment in default VPC
    # Default VPC lacks proper network segmentation and security controls
    postcondition {
      condition     = self.vpc_id != data.aws_vpc.default.id
      error_message = <<-EOT
        SECURITY VIOLATION: Subnet ${self.id} is part of the default VPC.
        RDS instances must not be deployed in the default VPC for security reasons.
        Please choose a subnet from a custom VPC with proper network segmentation.

        Subnet Details:
          - Subnet ID: ${self.id}
          - Subnet Name: ${self.tags.Name}
          - VPC ID: ${self.vpc_id}
          - Default VPC ID: ${data.aws_vpc.default.id}
        
        Resolution:
          - Create subnets in a custom VPC
          - Ensure proper network isolation
          - Follow security best practices
      EOT
    }

    # Validation 2: Ensure subnet is marked as private
    # RDS instances should only be deployed in private subnets
    postcondition {
      condition     = can(lower(self.tags.Access) == "private")
      error_message = <<-EOT
        SECURITY VIOLATION: Subnet ${self.id} is not marked as private.
        RDS instances must be deployed in private subnets to prevent direct internet access.
        Please choose a subnet with 'Access = Private' tag.

        Subnet Details:
          - Subnet ID: ${self.id}
          - Subnet Name: ${self.tags.Name}
          - Current Access Tag: ${try(self.tags.Access, "NOT SET")}
          - Required Access Tag: Private
        
        Resolution:
          - Add 'Access = Private' tag to the subnet
          - Ensure subnet has no internet gateway route
          - Use private subnets for database deployment
      EOT
    }
  }
}

# =============================================================================
# SECURITY GROUP VALIDATION
# =============================================================================

# Data source to fetch all rules for the provided security groups
# Used to validate security group configurations for compliance
data "aws_vpc_security_group_rules" "input" {
  filter {
    name   = "group-id"
    values = var.security_group_ids
  }
}

# Data source to validate each security group rule
# Implements security best practices validation for database access
data "aws_vpc_security_group_rule" "input" {
  # Create a data source for each security group rule
  for_each               = toset(data.aws_vpc_security_group_rules.input.ids)
  security_group_rule_id = each.value

  # Lifecycle management with postcondition validation
  # Ensures security group rules follow database security best practices
  lifecycle {
    # Validation: Prevent broad IP-based inbound access
    # Database access should only be allowed from specific security groups
    postcondition {
      condition = (
        # Allow all egress rules (outbound traffic)
        self.is_egress ? true : 
        # For ingress rules, ensure no direct IP access
        (self.cidr_ipv4 == null && self.cidr_ipv6 == null && self.referenced_security_group_id != null)
      )
      error_message = <<-EOT
        SECURITY VIOLATION: Security Group Rule ${self.id} allows inbound traffic from IP CIDR blocks.
        Database security groups must only allow access from other security groups, not direct IP ranges.
        This prevents unauthorized access and implements proper network segmentation.

        Rule Details:
          - Security Group Rule ID: ${self.id}
          - Security Group ID: ${self.security_group_id}
          - Is Egress Rule: ${self.is_egress}
          - IPv4 CIDR: ${self.cidr_ipv4}
          - IPv6 CIDR: ${self.cidr_ipv6}
          - Referenced Security Group: ${self.referenced_security_group_id}
        
        Security Requirements:
          1. Ingress rules must reference other security groups only
          2. No direct IP CIDR block access allowed
          3. Use security group references for controlled access
        
        Resolution:
          - Remove CIDR-based ingress rules
          - Use referenced_security_group_id instead
          - Implement proper security group architecture
      EOT
    }
  }
}
