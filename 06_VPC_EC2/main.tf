resource "aws_instance" "shah_web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp3"
  }
  vpc_security_group_ids = [aws_security_group.public_http_traffic.id]
  key_name               = aws_key_pair.shah_key_pair.key_name
  user_data              = file("${path.module}/websitesetup.sh")
  tags                   = merge(local.common_tags, { Name = "Shah Public Website Demo" })
}