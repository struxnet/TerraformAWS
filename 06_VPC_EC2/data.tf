# =============================================================================
# DATA SOURCES
# =============================================================================
# Data sources allow Terraform to fetch information from AWS that exists
# outside of Terraform's management. This is useful for referencing
# existing resources or getting dynamic information like the latest AMI.

# Data source to fetch the most recent Ubuntu AMI
# This ensures we always use the latest available Ubuntu image
# without hardcoding a specific AMI ID that might become outdated
data "aws_ami" "ubuntu" {
  # Get the most recently created AMI that matches our filters
  # This ensures we're using the latest security patches and updates
  most_recent = true

  # Filter AMIs by name pattern
  # This filter looks for Ubuntu 22.04 LTS (Jammy Jellyfish) server images
  filter {
    name = "name"
    # Pattern matches Ubuntu server AMIs with HVM virtualization and SSD storage
    # The asterisk (*) allows for version variations and build dates
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  # Filter by virtualization type
  # HVM (Hardware Virtual Machine) is the modern virtualization type
  # that provides better performance than paravirtual (PV)
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # Specify the AMI owner to ensure we get official Ubuntu images
  # 099720109477 is Canonical's official AWS account ID
  # This prevents accidentally using community or malicious AMIs
  owners = ["099720109477"]
}
