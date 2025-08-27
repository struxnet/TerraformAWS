# =============================================================================
# NETWORK INFRASTRUCTURE
# =============================================================================
# This file defines the complete network infrastructure including:
# - Virtual Private Cloud (VPC) for network isolation
# - Public and private subnets for different access patterns
# - Internet Gateway for external connectivity
# - Route tables for traffic routing
# This creates a standard 2-tier network architecture

# Create a Virtual Private Cloud (VPC)
# VPC provides an isolated network environment in AWS
# All resources will be deployed within this VPC for security and organization
resource "aws_vpc" "shah_vpc" {
  # Define the IP address range for the entire VPC
  # /16 subnet mask provides 65,536 IP addresses (10.0.0.0 - 10.0.255.255)
  # This gives plenty of room for multiple subnets and future expansion
  cidr_block = "${var.shah_vpc_ip_addr}/16"
  
  # Apply common tags plus VPC-specific name
  # Proper tagging is essential for resource management and cost tracking
  tags = merge(local.common_tags, { Name = "Shah VPC" })
}

# Create a public subnet for internet-facing resources
# Public subnets are used for resources that need direct internet access
# such as web servers, load balancers, and NAT gateways
resource "aws_subnet" "public" {
  # Associate this subnet with our VPC
  vpc_id = aws_vpc.shah_vpc.id
  
  # Define IP range for this subnet
  # /24 subnet mask provides 256 IP addresses (10.0.1.0 - 10.0.1.255)
  # This is sufficient for most public-facing resources
  cidr_block = "${var.shah_public_subnet_ip_addr}/24"
  
  # Automatically assign public IP addresses to instances launched in this subnet
  # This is what makes it a "public" subnet - instances get internet-routable IPs
  map_public_ip_on_launch = true
  
  # Apply common tags plus subnet-specific name
  tags = merge(local.common_tags, { Name = "Shah Public Subnet" })
}

# Create a private subnet for internal resources
# Private subnets are used for resources that should not be directly accessible
# from the internet, such as databases, internal APIs, and backend services
resource "aws_subnet" "private" {
  # Associate this subnet with our VPC
  vpc_id = aws_vpc.shah_vpc.id
  
  # Define IP range for this subnet
  # /24 subnet mask provides 256 IP addresses (10.0.2.0 - 10.0.2.255)
  # Separate IP range from public subnet for clear network segmentation
  cidr_block = "${var.shah_private_subnet_ip_addr}/24"
  
  # Apply common tags plus subnet-specific name
  tags = merge(local.common_tags, { Name = "Shah Private Subnet" })
}

# Create an Internet Gateway for external connectivity
# Internet Gateway enables communication between the VPC and the internet
# Required for any resources that need internet access (inbound or outbound)
resource "aws_internet_gateway" "shah_igw" {
  # Attach the Internet Gateway to our VPC
  # Each VPC can have only one Internet Gateway
  vpc_id = aws_vpc.shah_vpc.id
  
  # Apply common tags plus gateway-specific name
  tags = merge(local.common_tags, { Name = "Shah Internet Gateway" })
}

# Create a route table for public subnet traffic routing
# Route tables determine where network traffic is directed
# This route table will direct internet traffic to the Internet Gateway
resource "aws_route_table" "public_rt" {
  # Associate this route table with our VPC
  vpc_id = aws_vpc.shah_vpc.id
  
  # Define a route for internet traffic
  # This route sends all traffic (0.0.0.0/0) to the Internet Gateway
  route {
    # 0.0.0.0/0 means "all IP addresses" - this is the default route
    cidr_block = "${var.shah_rt_ip_addr}/0"
    
    # Direct this traffic to our Internet Gateway
    # This enables internet connectivity for resources in associated subnets
    gateway_id = aws_internet_gateway.shah_igw.id
  }
}

# Associate the public subnet with the public route table
# This association makes the subnet "public" by giving it internet access
# Without this association, the subnet would not have internet connectivity
resource "aws_route_table_association" "rt_association" {
  # Specify which subnet to associate
  subnet_id = aws_subnet.public.id
  
  # Specify which route table to use
  # This connects the public subnet to the route table with internet access
  route_table_id = aws_route_table.public_rt.id
}