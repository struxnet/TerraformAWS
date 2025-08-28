resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu_latest_ami.image_id
  instance_type = var.instance_size
  root_block_device {
    volume_size           = var.volume_config.size
    volume_type           = var.volume_config.type
    delete_on_termination = true
  }

  tags = merge(local.common_tags, var.additional_tags)
}