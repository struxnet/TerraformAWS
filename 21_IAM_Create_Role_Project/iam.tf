# =============================================================================
# IAM USERS MANAGEMENT
# =============================================================================
# This file manages IAM users and their login profiles based on configuration
# defined in the users-roles.yaml file. It creates users, generates passwords,
# and establishes the mapping between users and their assigned roles.

# Local values for processing user configuration from YAML file
locals {
  # Parse the YAML configuration file to extract user definitions
  # The YAML file contains user information including usernames and role assignments
  users_yaml = yamldecode(file("${path.module}/users-roles.yaml")).users
  
  # Create a map structure for easier lookup of user roles
  # This transforms the list structure into a key-value map where:
  # - Key: username (string)
  # - Value: list of roles assigned to that user
  # This structure is used later for role assumption policy generation
  users_map = {
    for user in local.users_yaml : user.username => user.roles
  }
}

# Create IAM users based on the YAML configuration
# This resource dynamically creates all users defined in the users-roles.yaml file
resource "aws_iam_user" "users" {
  # Use for_each to create one user resource for each username in the YAML
  # toset() converts the list to a set to ensure uniqueness
  # The [*] syntax extracts all username values from the users_yaml list
  for_each = toset(local.users_yaml[*].username)
  
  # Set the IAM user name to the username from the configuration
  # each.value contains the current username being processed
  name = each.value
}

# Create login profiles for console access
# Login profiles enable users to sign in to the AWS Management Console
# with a username and password
resource "aws_iam_user_login_profile" "login_profile" {
  # Create a login profile for each IAM user created above
  # This establishes a 1:1 relationship between users and login profiles
  for_each = aws_iam_user.users
  
  # Associate the login profile with the corresponding IAM user
  user = each.value.name
  
  # Set password length to 10 characters
  # This meets most security requirements while remaining manageable
  password_length = 10
  
  # Force users to change password on first login
  # This is a security best practice to ensure users set their own passwords
  password_reset_required = true

  # Lifecycle configuration to prevent unwanted changes
  # These settings prevent Terraform from modifying certain attributes
  # after the initial creation, allowing for manual password management
  lifecycle {
    ignore_changes = [
      password_length,         # Don't change password length after creation
      password_reset_required, # Don't modify reset requirement after creation
      pgp_key                 # Don't change PGP key configuration
    ]
  }
}

# Output the generated passwords for initial user setup
# This output is marked as sensitive to prevent accidental exposure in logs
output "passwords" {
  # Mark as sensitive to hide values in Terraform output and logs
  # Passwords should never be displayed in plain text
  sensitive = true
  
  # Create a map of usernames to their generated passwords
  # This allows administrators to retrieve initial passwords for user setup
  # Format: { "username1" => "password1", "username2" => "password2" }
  value = { for user, user_login in aws_iam_user_login_profile.login_profile : user => user_login.password }
}
