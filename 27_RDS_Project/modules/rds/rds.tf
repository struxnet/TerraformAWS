# =============================================================================
# RDS MODULE - DATABASE INSTANCE CONFIGURATION
# =============================================================================
# This module creates a complete RDS database instance with proper security
# configurations, parameter groups, and subnet groups. It demonstrates
# best practices for database deployment and management.

# Local values for database engine configurations
# Provides a mapping of engine aliases to specific versions and families
# Enables easy engine selection while maintaining version control
locals {
  db_engine = {
    # Latest PostgreSQL configuration
    postgres-latest = {
      engine  = "postgres"    # PostgreSQL engine
      version = "16.1"        # Latest stable version
      family  = "postgres16"  # Parameter group family
    }
    # PostgreSQL 14 configuration for compatibility
    postgres-14 = {
      engine  = "postgres"    # PostgreSQL engine
      version = "14.11"       # Stable LTS version
      family  = "postgres14"  # Parameter group family
    }
  }
}

# DB Subnet Group for RDS deployment
# Groups subnets across multiple availability zones for high availability
# Required for RDS instances deployed in VPC
resource "aws_db_subnet_group" "this" {
  # Unique name for the subnet group
  name = "${var.project_name}-db-subnet-group"
  
  # List of subnet IDs where RDS can be deployed
  # Must span at least two availability zones for multi-AZ deployment
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# DB Parameter Group for custom database configuration
# Allows customization of database engine parameters
# Enables performance tuning and security hardening
resource "aws_db_parameter_group" "this" {
  # Unique name for the parameter group
  name = "${var.project_name}-db-parameter-group"
  
  # Parameter group family based on selected engine
  family = local.db_engine[var.engine].family
  
  # Description for documentation and identification
  description = "Custom parameter group for ${var.project_name} RDS instance"

  tags = {
    Name = "${var.project_name}-db-parameter-group"
  }
  
  # Custom parameter for connection logging
  # Enables logging of database connections for security auditing
  parameter {
    name  = "log_connections"  # PostgreSQL parameter name
    value = "1"               # Enable connection logging
  }
}

# RDS Database Instance
# Main database resource with comprehensive security and performance configuration
resource "aws_db_instance" "this" {
  # Unique identifier for the RDS instance
  identifier = "${var.project_name}-db-instance"
  
  # Database engine configuration from local mapping
  engine         = local.db_engine[var.engine].engine
  engine_version = local.db_engine[var.engine].version
  
  # Instance specifications
  instance_class    = var.instance_class  # Compute and memory capacity
  allocated_storage = var.storage_size     # Storage size in GB
  
  # Network and security configuration
  db_subnet_group_name   = aws_db_subnet_group.this.name  # Subnet placement
  vpc_security_group_ids = var.security_group_ids         # Security groups
  
  # Database credentials
  # Note: In production, use AWS Secrets Manager for credential management
  username = var.credentials.username
  password = var.credentials.password
  
  # Security settings
  publicly_accessible = false  # Prevent public internet access
  
  # Backup and maintenance settings
  skip_final_snapshot = true  # Skip final snapshot on deletion (dev/test only)
  
  # Custom parameter group
  parameter_group_name = aws_db_parameter_group.this.name
  
  tags = {
    Name = "${var.project_name}-db-instance"
  }
}
