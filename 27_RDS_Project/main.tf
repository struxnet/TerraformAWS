# =============================================================================
# RDS DATABASE DEPLOYMENT
# =============================================================================
# This file demonstrates the usage of a custom RDS module to deploy
# a PostgreSQL database instance with proper security configurations,
# network isolation, and compliance validation.

# RDS module instantiation with comprehensive configuration
# Deploys a PostgreSQL database with security best practices
module "database" {
  # Path to the custom RDS module
  source = "./modules/rds"
  
  # Project identifier for resource naming and tagging
  project_name = "rds-project-terraform"
  
  # Database instance specifications
  # db.t3.micro provides cost-effective performance for development/testing
  instance_class = "db.t3.micro"
  
  # Storage allocation in GB
  # 10 GB provides adequate space for small to medium databases
  storage_size = 10
  
  # Database engine selection
  # postgres-latest uses the most recent PostgreSQL version (16.1)
  engine = "postgres-latest"
  
  # Database credentials configuration
  # Note: In production, use AWS Secrets Manager or parameter store
  credentials = {
    username = "dbadmin"      # Database administrator username
    password = "Password9@"   # Strong password meeting complexity requirements
  }
  
  # Security group configuration
  # Uses compliant security group that restricts access to specific sources
  security_group_ids = [aws_security_group.compliant.id]
  
  # Subnet configuration for multi-AZ deployment
  # All subnets are private and span multiple availability zones
  # Provides high availability and network isolation
  subnet_ids = [
    aws_subnet.allowed_subnets.id,    # us-west-1b private subnet
    aws_subnet.allowed_subnets_2.id,  # us-west-1c private subnet
    aws_subnet.allowed_subnets_3.id,  # Additional private subnet
  ]
}