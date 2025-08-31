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
resource "aws_instance" "cloud_instance" {
  ami           = data.aws_ami.ubuntu_latest_ami.id
  instance_type = var.ec2_instance_type

  tags = {
    Name = "Terraform-Cloud"
  }
}