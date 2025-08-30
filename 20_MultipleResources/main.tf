locals {
  ami_id = {
    ubuntu = data.aws_ami.ubuntu_latest_ami.id
    nginx  = data.aws_ami.nginx.id
  }
}

resource "aws_instance" "from_list" {
  count         = length(var.ec2_instance_config_list)
  ami           = local.ami_id[var.ec2_instance_config_list[count.index].ami]
  instance_type = var.ec2_instance_config_list[count.index].instance_type
  subnet_id     = aws_subnet.main["default"].id

  tags = {
    Name    = "${local.Project}-instance-${count.index}"
    Project = local.Project
  }
}

resource "aws_instance" "from_map" {
  for_each      = var.ec2_instance_config_map
  ami           = local.ami_id[each.value.ami]
  instance_type = each.value.instance_type
  subnet_id     = aws_subnet.main[each.value.subnet_name].id

  tags = {
    Name    = "${local.Project}-instance-${each.key}"
    Project = local.Project
  }
}