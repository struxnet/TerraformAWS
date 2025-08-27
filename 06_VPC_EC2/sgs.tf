# =============================================================================
# SECURITY GROUPS
# =============================================================================
# Security groups act as virtual firewalls that control inbound and outbound
# traffic for AWS resources. They operate at the instance level and use
# stateful filtering (return traffic is automatically allowed).
# This file defines security rules for web server access.

# Create a security group for public web traffic
# This security group will be attached to EC2 instances that need to serve
# web content and allow administrative access via SSH
resource "aws_security_group" "public_http_traffic" {
  # Human-readable description of the security group's purpose
  description = "Security group to allow traffic on port 443 and port 80"
  
  # Unique name for the security group within the VPC
  name = "public-http-traffic"
  
  # Associate this security group with our VPC
  # Security groups are VPC-specific and cannot be used across VPCs
  vpc_id = aws_vpc.shah_vpc.id
  
  # Apply common tags plus security group-specific name
  tags = merge(local.common_tags, { Name = "Shah HTTP and SSH Security Group" })
}

# Allow inbound HTTP traffic (port 80) from anywhere on the internet
# HTTP is the standard protocol for web traffic, though it's unencrypted
# This rule enables users to access the website via http://
resource "aws_vpc_security_group_ingress_rule" "http" {
  # Reference the security group this rule applies to
  security_group_id = aws_security_group.public_http_traffic.id
  
  # Allow traffic from any IPv4 address on the internet
  # 0.0.0.0/0 represents all possible IP addresses
  cidr_ipv4 = "0.0.0.0/0"
  
  # Define the port range for HTTP traffic
  # HTTP uses port 80 by convention
  from_port = var.http
  to_port   = var.http
  
  # Specify TCP protocol (HTTP runs over TCP)
  ip_protocol = "tcp"
  
  # Apply tags for rule identification and management
  tags = merge(local.common_tags, { Name = "HTTP Allow" })
}

# Allow inbound HTTPS traffic (port 443) from anywhere on the internet
# HTTPS is the secure version of HTTP with SSL/TLS encryption
# This rule enables users to access the website via https://
resource "aws_vpc_security_group_ingress_rule" "https" {
  # Reference the security group this rule applies to
  security_group_id = aws_security_group.public_http_traffic.id
  
  # Allow traffic from any IPv4 address on the internet
  # 0.0.0.0/0 represents all possible IP addresses
  cidr_ipv4 = "0.0.0.0/0"
  
  # Define the port range for HTTPS traffic
  # HTTPS uses port 443 by convention
  from_port = var.https
  to_port   = var.https
  
  # Specify TCP protocol (HTTPS runs over TCP)
  ip_protocol = "tcp"
  
  # Apply tags for rule identification and management
  tags = merge(local.common_tags, { Name = "HTTPS Allow" })
}

# Allow inbound SSH traffic (port 22) from a specific IP address
# SSH provides secure remote access for server administration
# SECURITY NOTE: This is restricted to a single IP for enhanced security
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  # Reference the security group this rule applies to
  security_group_id = aws_security_group.public_http_traffic.id
  
  # IMPORTANT: Restrict SSH access to a specific public IP address
  # /32 means exactly this IP address (no range)
  # Change this to your actual public IP address for security
  # Find your IP at: https://whatismyipaddress.com/
  cidr_ipv4 = "70.77.110.238/32"
  
  # Define the port range for SSH traffic
  # SSH uses port 22 by convention
  from_port = var.ssh
  to_port   = var.ssh
  
  # Specify TCP protocol (SSH runs over TCP)
  ip_protocol = "tcp"
  
  # Apply tags for rule identification and management
  tags = merge(local.common_tags, { Name = "SSH Allow" })
}