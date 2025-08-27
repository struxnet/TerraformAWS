resource "aws_security_group" "public_http_traffic" {
  description = "Security group to allow traffic on port 443 and port 80"
  name        = "public-http-traffic"
  vpc_id      = aws_vpc.shah_vpc.id
  tags        = merge(local.common_tags, { Name = "Shah HTTP and SSH Security Group" })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.http
  to_port           = var.http
  ip_protocol       = "tcp"
  tags              = merge(local.common_tags, { Name = "HTTP Allow" })
}
resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.https
  to_port           = var.https
  ip_protocol       = "tcp"
  tags              = merge(local.common_tags, { Name = "HTTPS Allow" })
}
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "70.77.110.238/32" #Public IP of your own internet. Change to your own public ip by going to https://whatismyipaddress.com/. Make sure the cidr remains /32
  from_port         = var.ssh
  to_port           = var.ssh
  ip_protocol       = "tcp"
  tags              = merge(local.common_tags, { Name = "SSH Allow" })
}