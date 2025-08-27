resource "tls_private_key" "shah_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "shah_key_pair" {
  key_name   = "shah-key"
  public_key = tls_private_key.shah_private_key.public_key_openssh
}