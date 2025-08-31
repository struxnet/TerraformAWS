/*
Terraform state mv ARGS
Moved Block
*/

locals {
  ec2_names = ["ec2_1", "ec2_2", "ec2_3"]
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

moved {
  from = aws_instance.name[0]
  to   = aws_instance.name["ec1"]
}
resource "aws_instance" "name" {
  for_each      = toset(local.ec2_names)
  ami           = data.aws_ami.ubuntu_latest_ami.id
  instance_type = "t2.micro"
}