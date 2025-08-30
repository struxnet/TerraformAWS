# =============================================================================
# MAIN CONFIGURATION - EC2 INSTANCE DEPLOYMENT
# =============================================================================
# This file demonstrates the usage of the custom VPC network module by
# deploying an EC2 instance into the module-created private subnet.
# It showcases how to consume module outputs and integrate them with
# other AWS resources in a modular architecture.

# Local values for consistent configuration across resources
# These values promote reusability and maintainability by centralizing
# common configuration parameters that might be used across multiple resources
locals {
  # EC2 instance type specification
  # t3.micro provides a good balance of compute, memory, and network resources
  # for development and testing workloads while remaining cost-effective
  instance_type = "t3.micro"
  
  # Common resource tags for consistent labeling and cost tracking
  # These tags will be applied to resources to enable:
  # - Resource identification and organization
  # - Cost allocation and tracking
  # - Automated operations and lifecycle management
  tags = {
    Name    = "EC2 Through Module"  # Human-readable resource identifier
    Project = "Modules"             # Project classification for grouping
  }
}

# Data source to fetch the latest Ubuntu 22.04 LTS AMI
# Using a data source ensures we always deploy with the most recent
# security patches and updates, rather than hardcoding an AMI ID
# that could become outdated or unavailable
data "aws_ami" "ubuntu_latest_ami" {
  # Retrieve the most recently published AMI matching our criteria
  # This ensures we get the latest security updates and patches
  most_recent = true
  
  # Canonical's official AWS account ID for Ubuntu AMIs
  # This ensures we only use official, trusted Ubuntu images
  # and avoid potentially malicious community AMIs
  owners = ["099720109477"]

  # Filter for Ubuntu 22.04 LTS server images
  # The wildcard pattern allows for different build dates and versions
  # while ensuring we get Ubuntu 22.04 (Jammy Jellyfish) specifically
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-*"]
  }

  # Filter for Hardware Virtual Machine (HVM) virtualization
  # HVM provides better performance and is the modern standard
  # compared to paravirtual (PV) virtualization
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 instance deployed using the custom network module
# This demonstrates how to consume module outputs and integrate
# modular infrastructure components in a real-world scenario
resource "aws_instance" "from_list" {
  # Use the dynamically fetched Ubuntu AMI
  # This ensures we're always using the latest available image
  ami = data.aws_ami.ubuntu_latest_ami.id
  
  # Instance type from local values for consistency
  instance_type = local.instance_type
  
  # Deploy into the private subnet created by our network module
  # This demonstrates module output consumption and shows how
  # the instance will be isolated from direct internet access
  # Note: "subnet_1" corresponds to the key defined in networks.tf
  subnet_id = module.networks.private_subnets["subnet_1"].subnet_id

  # Apply consistent tagging using local values
  # This ensures all resources follow the same tagging strategy
  # for better organization and cost management
  tags = {
    Name    = local.tags.Name     # Instance display name
    Project = local.tags.Project  # Project association
  }
}