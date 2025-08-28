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

data "aws_ami" "ubuntu_latest_ami_us_east" {
  most_recent = true
  owners      = ["099720109477"] # Owner is Canonical
  provider    = aws.us-east
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu_latest_ami.image_id
}

output "ubuntu_ami_id_us_east" {
  value = data.aws_ami.ubuntu_latest_ami_us_east.image_id
}