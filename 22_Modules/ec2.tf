locals {
  instance_type = "t3.micro"
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

module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                   = "${local.project_name}-ec2"
  ami                    = data.aws_ami.ubuntu_latest_ami.id
  instance_type          = local.instance_type
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  tags                   = local.common_tags
}