resource "aws_instance" "web" {

  ami                         = data.aws_ami.ubuntu_latest_ami.image_id
  associate_public_ip_address = true
  instance_type               = "t3.micro"
  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp3"
  }
}