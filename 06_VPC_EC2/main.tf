# =============================================================================
# EC2 INSTANCE CONFIGURATION
# =============================================================================
# This file defines the main EC2 instance that will host our web application.
# The instance is configured with all necessary components for a web server
# including networking, security, storage, and initialization scripts.

# Create an EC2 instance for hosting the web application
# This instance will be publicly accessible and configured as a web server
resource "aws_instance" "shah_web" {
  # Use the Ubuntu AMI fetched from the data source
  # This ensures we're using the latest Ubuntu 22.04 LTS image
  ami = data.aws_ami.ubuntu.id
  
  # Instance type determines the compute resources (CPU, memory, network)
  # Using a variable allows for easy scaling up/down in different environments
  instance_type = var.instance_type
  
  # Automatically assign a public IP address to the instance
  # This makes the instance directly accessible from the internet
  # Required for public-facing web servers
  associate_public_ip_address = true
  
  # Place the instance in the public subnet
  # Public subnets have routes to the internet gateway for external access
  subnet_id = aws_subnet.public.id
  
  # Configure the root EBS volume (primary storage)
  # This block defines the characteristics of the instance's main disk
  root_block_device {
    # Automatically delete the volume when the instance is terminated
    # This prevents orphaned volumes and reduces storage costs
    delete_on_termination = true
    
    # Set volume size to 8 GB
    # Sufficient for a basic web server with Ubuntu and application files
    volume_size = 8
    
    # Use GP3 volume type for better performance and cost efficiency
    # GP3 provides better IOPS and throughput compared to GP2
    volume_type = "gp3"
  }
  
  # Attach security groups to control network traffic
  # Security groups act as virtual firewalls for the instance
  vpc_security_group_ids = [aws_security_group.public_http_traffic.id]
  
  # Associate the SSH key pair for secure remote access
  # This allows administrators to SSH into the instance using the private key
  key_name = aws_key_pair.shah_key_pair.key_name
  
  # Execute initialization script when the instance first boots
  # This script will install and configure the web server software
  user_data = file("${path.module}/websitesetup.sh")
  
  # Apply common tags plus instance-specific name tag
  # Tags help with resource identification, cost tracking, and automation
  tags = merge(local.common_tags, { Name = "Shah Public Website Demo" })
}