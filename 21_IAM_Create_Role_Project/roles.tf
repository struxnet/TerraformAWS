# =============================================================================
# IAM ROLES AND POLICY MANAGEMENT
# =============================================================================
# This file defines IAM roles with specific permission sets and manages
# the assignment of AWS managed policies to these roles. It also creates
# assume role policies that determine which users can assume each role.

# Local values for role and policy configuration
locals {
  # Define role-to-policy mappings
  # Each role is associated with one or more AWS managed policies
  # This structure allows for easy modification of role permissions
  roles_policies = {
    # Read-only role for users who need view-only access
    # Suitable for auditors, junior staff, or external consultants
    readonly = [
      "ReadOnlyAccess"  # AWS managed policy providing read-only access to all services
    ]
    
    # Administrative role with full access to all AWS services
    # Should be assigned sparingly and only to trusted administrators
    admin = [
      "AdministratorAccess"  # AWS managed policy providing full access to all services
    ]
    
    # Security audit role for compliance and security reviews
    # Provides access to security-related information without modification rights
    securityAudit = [
      "SecurityAudit"  # AWS managed policy for security auditing and compliance
    ]
    
    # Developer role with access to common development services
    # Provides necessary permissions for application development and deployment
    developer = [
      "AmazonVPCFullAccess",     # Full access to VPC for network configuration
      "AmazonEC2FullAccess",     # Full access to EC2 for compute resources
      "AmazonS3FullAccess",      # Full access to S3 for storage operations
      "AWSLambda_FullAccess",    # Full access to Lambda for serverless functions
      "AmazonRDSFullAccess"      # Full access to RDS for database management
    ]
  }

  # Flatten the role-policy mapping into a list for easier iteration
  # This transformation creates a list of objects with role and policy pairs
  # Used later for attaching multiple policies to roles
  role_policies_list = flatten([
    for role, policies in local.roles_policies : [
      for policy in policies : {
        role   = role    # Role name (e.g., "developer", "admin")
        policy = policy  # Policy name (e.g., "AmazonS3FullAccess")
      }
    ]
  ])
}

# Create assume role policy documents for each role
# These policies determine which users are allowed to assume each role
# The policy is dynamically generated based on user-role assignments in YAML
data "aws_iam_policy_document" "assume_role" {
  # Create one assume role policy for each defined role
  for_each = toset(keys(local.roles_policies))
  
  # Define the policy statement that allows role assumption
  statement {
    # Allow the STS AssumeRole action
    # This is the API call that enables users to assume the role
    actions = ["sts:AssumeRole"]
    
    # Define which AWS principals can assume this role
    principals {
      type = "AWS"  # Specify AWS IAM users as the principal type
      
      # Dynamically build list of user ARNs who can assume this role
      # Only includes users who have this specific role in their YAML configuration
      identifiers = [
        for username in keys(aws_iam_user.users) : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${username}"
        if contains(local.users_map[username], each.value)  # Check if user has this role assigned
      ]
    }
  }
}

# Fetch AWS managed policies for attachment to roles
# This data source retrieves the actual policy documents from AWS
data "aws_iam_policy" "aws_manage_policies" {
  # Create a data source for each unique policy referenced in roles_policies
  for_each = toset(local.role_policies_list[*].policy)
  
  # Construct the ARN for the AWS managed policy
  # AWS managed policies follow a standard ARN format
  arn = "arn:aws:iam::aws:policy/${each.value}"
}

# Get current AWS account information
# Used to construct ARNs and for account-specific configurations
data "aws_caller_identity" "current" {}

# Create IAM roles with their assume role policies
# Each role is created with a policy that defines who can assume it
resource "aws_iam_role" "roles" {
  # Create one role for each role type defined in roles_policies
  for_each = toset(keys(local.roles_policies))
  
  # Set the role name to match the role type (e.g., "developer", "admin")
  name = each.key
  
  # Attach the dynamically generated assume role policy
  # This policy determines which users can assume this role
  assume_role_policy = data.aws_iam_policy_document.assume_role[each.value].json
}

# Attach AWS managed policies to the created roles
# This establishes the actual permissions that each role provides
resource "aws_iam_role_policy_attachment" "roles_policy_attachment" {
  # Create one attachment for each role-policy combination
  # Using count instead of for_each for this specific use case
  count = length(local.role_policies_list)
  
  # Specify which role to attach the policy to
  # Uses the flattened list to map policies to their corresponding roles
  role = aws_iam_role.roles[local.role_policies_list[count.index].role].name
  
  # Specify which policy to attach
  # References the AWS managed policy ARN from the data source
  policy_arn = data.aws_iam_policy.aws_manage_policies[local.role_policies_list[count.index].policy].arn
}