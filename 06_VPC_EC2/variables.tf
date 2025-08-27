# =============================================================================
# INPUT VARIABLES
# =============================================================================
# Variables allow you to parameterize your Terraform configuration,
# making it reusable across different environments and deployments.
# Each variable can have a default value, type constraints, and validation rules.

# VPC CIDR block base IP address
# This defines the starting IP address for the VPC network range
# Combined with /16 subnet mask, this creates the VPC's IP address space
variable "shah_vpc_ip_addr" {
  description = "Base IP address for the VPC CIDR block"
  type        = string
  default     = "10.0.0.0"
  
  # 10.0.0.0 is part of the private IP address range (RFC 1918)
  # Safe to use in any AWS region without conflicts
}

# Public subnet CIDR block base IP address
# This defines the IP range for resources that need internet access
# Must be within the VPC CIDR range
variable "shah_public_subnet_ip_addr" {
  description = "Base IP address for the public subnet CIDR block"
  type        = string
  default     = "10.0.1.0"
  
  # 10.0.1.0/24 provides 256 IP addresses (10.0.1.0 - 10.0.1.255)
  # Sufficient for most public-facing resources
}

# Private subnet CIDR block base IP address
# This defines the IP range for internal resources without direct internet access
# Must be within the VPC CIDR range and not overlap with public subnet
variable "shah_private_subnet_ip_addr" {
  description = "Base IP address for the private subnet CIDR block"
  type        = string
  default     = "10.0.2.0"
  
  # 10.0.2.0/24 provides 256 IP addresses (10.0.2.0 - 10.0.2.255)
  # Separate range ensures no IP conflicts with public subnet
}

# Route table default route IP address
# This is used for the default route that directs traffic to the internet
# 0.0.0.0 represents "all IP addresses" for the default route
variable "shah_rt_ip_addr" {
  description = "Base IP address for the default route (typically 0.0.0.0 for internet access)"
  type        = string
  default     = "0.0.0.0"
  
  # 0.0.0.0/0 is the standard notation for a default route
  # This routes all traffic not matching other routes to the internet gateway
}

# EC2 instance type specification
# Determines the compute resources (CPU, memory, network, storage) for the instance
# Different instance types are optimized for different workloads
variable "instance_type" {
  description = "EC2 instance type for the web server"
  type        = string
  default     = "t3.micro"
  
  # t3.micro provides:
  # - 2 vCPUs (burstable performance)
  # - 1 GB RAM
  # - Low to moderate network performance
  # - Eligible for AWS Free Tier
}

# HTTP port number
# Standard port for unencrypted web traffic
# Used in security group rules and application configuration
variable "http" {
  description = "Port number for HTTP traffic"
  type        = string
  default     = "80"
  
  # Port 80 is the standard port for HTTP traffic
  # Web browsers automatically use this port for http:// URLs
}

# HTTPS port number
# Standard port for encrypted web traffic (SSL/TLS)
# Used in security group rules and application configuration
variable "https" {
  description = "Port number for HTTPS traffic"
  type        = string
  default     = "443"
  
  # Port 443 is the standard port for HTTPS traffic
  # Web browsers automatically use this port for https:// URLs
}

# SSH port number
# Standard port for Secure Shell remote access
# Used for server administration and file transfers
variable "ssh" {
  description = "Port number for SSH traffic"
  type        = string
  default     = "22"
  
  # Port 22 is the standard port for SSH traffic
  # Used by SSH clients for secure remote access
}