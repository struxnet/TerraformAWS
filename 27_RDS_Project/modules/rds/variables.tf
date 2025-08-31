# =============================================================================
# RDS MODULE INPUT VARIABLES
# =============================================================================
# This file defines all input variables for the RDS module with comprehensive
# validation rules to ensure secure and compliant database deployments.
# Variables include instance specifications, networking, and security settings.

# =============================================================================
# PROJECT IDENTIFICATION
# =============================================================================

# Project name for resource naming and tagging
# Used as a prefix for all RDS-related resources
variable "project_name" {
  type        = string
  description = "The project name used for naming RDS resources and tagging"
}

# =============================================================================
# RDS INSTANCE SPECIFICATIONS
# =============================================================================

# Database instance class specification
# Determines compute, memory, and network capacity
variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "Instance class for the RDS instance (compute and memory capacity)"
  
  # Validation to restrict to free tier eligible instances
  # Prevents accidental deployment of expensive instance types
  validation {
    condition     = contains(["db.t2.micro", "db.t3.micro"], var.instance_class)
    error_message = "Only Micro instances are allowed due to free tier access. Allowed values: db.t2.micro, db.t3.micro"
  }
}

# Database storage allocation
# Defines the amount of storage allocated to the RDS instance
variable "storage_size" {
  type        = number
  description = "The allocated storage size for the RDS instance in GB"
  default     = 10
  
  # Validation to ensure reasonable storage limits
  # Prevents over-provisioning and excessive costs
  validation {
    condition     = var.storage_size >= 5 && var.storage_size <= 15
    error_message = "Storage size must be between 5 GB and 15 GB for cost control."
  }
}

# Database engine selection
# Supports multiple database engines with version control
variable "engine" {
  type        = string
  description = "The database engine for the RDS instance"
  default     = "postgres-latest"

  # Validation to restrict to supported engines
  # Currently supports PostgreSQL and MySQL latest versions
  validation {
    condition     = contains(["mysql-latest", "postgres-latest"], var.engine)
    error_message = "Engine must be either 'mysql-latest' or 'postgres-latest'."
  }
}

# =============================================================================
# DATABASE CREDENTIALS
# =============================================================================

# Database administrator credentials
# Contains username and password for database access
variable "credentials" {
  type = object({
    username = string  # Database administrator username
    password = string  # Database administrator password
  })
  description = "Database administrator credentials (username and password)"
  sensitive   = true  # Marks variable as sensitive to prevent exposure in logs
  
  # Comprehensive password validation for security
  # Ensures strong password requirements are met
  validation {
    condition = (
      # Password must be at least 8 characters with allowed special characters
      length(regexall("^[a-zA-Z0-9+_?-@!]{8,}$", var.credentials.password)) > 0
      # Must contain at least one number
      && length(regexall("[0-9]", var.credentials.password)) > 0
      # Must contain at least one letter
      && length(regexall("[a-zA-Z]", var.credentials.password)) > 0
    )
    error_message = "Password must be at least 8 characters long and contain alphanumeric and special characters (+_?-@!)."
  }
}

# =============================================================================
# NETWORKING AND SECURITY CONFIGURATION
# =============================================================================

# Subnet IDs for RDS deployment
# Must include subnets from at least two availability zones
variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs where the RDS instance will be deployed (minimum 2 AZs required)"
  
  # Note: Additional validation for subnet compliance is handled in networks.tf
  # Subnets must be private and not in the default VPC
}

# Security group IDs for database access control
# Defines which resources can access the database
variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to associate with the RDS instance for access control"
  
  # Note: Additional validation for security group compliance is handled in networks.tf
  # Security groups must not allow broad IP-based access
}