locals {
  Project = "20-MultipleResources"
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

data "aws_ami" "nginx" {

  filter {
    name   = "name"
    values = ["bitnami-nginx-1.29.1-r02-debian-12-amd64-f5774628-e459-457a-b058-3b513caefdee"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu_latest_ami.image_id
}
