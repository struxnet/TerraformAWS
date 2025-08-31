locals {
  allowed_instance_types = ["t3.micro"]
}

data "aws_ami" "ubuntu_latest_ami" {
  most_recent = true
  owners      = ["099720109477"] # Owner is Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {

  ami                         = data.aws_ami.ubuntu_latest_ami.image_id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp3"
  }
  

  lifecycle {
    create_before_destroy = true
    postcondition {

      condition     = contains(local.allowed_instance_types, self.instance_type)
      error_message = "Instance type is not allowed"
    }
  }
}

check "cost_center" {
  assert {
    condition     = can(aws_instance.web.tags.CostCenter != "")
    error_message = "Cost center is not set"
  }

}