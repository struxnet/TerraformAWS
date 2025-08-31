# =============================================================================
# NETWORK INFRASTRUCTURE FOR RDS PROJECT
# =============================================================================
# This file creates the network infrastructure required for RDS deployment,
# including VPC, subnets, and demonstration of compliant vs non-compliant
# network configurations for database security best practices.

# Data source to reference the default VPC
# Used for demonstration purposes to show non-compliant subnet placement
data "aws_vpc" "default" {
  default = true
}

# Custom VPC for database deployment
# Provides isolated network environment for RDS instances
# Following best practices for database security and network segmentation
resource "aws_vpc" "db_vpc" {
  # CIDR block providing 65,536 IP addresses for database infrastructure
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "db_vpc"
  }
}

# Private subnet in availability zone us-west-1b
# Compliant subnet for RDS deployment - marked as "Private" for validation
# Part of multi-AZ setup for high availability
resource "aws_subnet" "allowed_subnets" {
  vpc_id            = aws_vpc.db_vpc.id
  availability_zone = "us-west-1b"
  cidr_block        = "10.0.1.0/24"  # 256 IP addresses
  
  tags = {
    Name   = "custom-subnet-vpc-allowed"
    Access = "Private"  # Required tag for RDS module validation
  }
}

# Private subnet in availability zone us-west-1c
# Second compliant subnet for RDS multi-AZ deployment
# Provides redundancy and high availability
resource "aws_subnet" "allowed_subnets_2" {
  vpc_id            = aws_vpc.db_vpc.id
  availability_zone = "us-west-1c"
  cidr_block        = "10.0.2.0/24"  # 256 IP addresses
  
  tags = {
    Name   = "custom-subnet-vpc-allowed-02"
    Access = "Private"  # Required tag for RDS module validation
  }
}

# Third private subnet for additional redundancy
# Note: No explicit availability zone specified - AWS will assign automatically
# Provides additional subnet for RDS subnet group requirements
resource "aws_subnet" "allowed_subnets_3" {
  vpc_id     = aws_vpc.db_vpc.id
  cidr_block = "10.0.3.0/24"  # 256 IP addresses
  
  tags = {
    Name   = "custom-subnet-vpc-allowed-03"
    Access = "Private"  # Required tag for RDS module validation
  }
}

# Non-compliant subnet for demonstration purposes
# Shows what happens when trying to use default VPC subnets
# This subnet will fail RDS module validation checks
resource "aws_subnet" "not_allowed_subnets" {
  vpc_id     = data.aws_vpc.default.id  # Uses default VPC (non-compliant)
  cidr_block = "172.31.192.0/24"
  
  tags = {
    Name = "custom-subnet-vpc-not-allowed"
    # Missing "Access = Private" tag - will fail validation
  }
}

# Public subnet for demonstration purposes
# Shows subnet that would fail RDS module validation
# Public subnets are not suitable for database deployment
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.db_vpc.id
  cidr_block = "10.0.0.0/24"  # 256 IP addresses
  
  tags = {
    Name   = "custom-subnet-vpc-public"
    Access = "Public"  # Will fail RDS module validation (not "Private")
  }
}