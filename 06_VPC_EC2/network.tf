resource "aws_vpc" "shah_vpc" {
  cidr_block = "${var.shah_vpc_ip_addr}/16"
  tags       = merge(local.common_tags, { Name = "Shah VPC" })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.shah_vpc.id
  cidr_block              = "${var.shah_public_subnet_ip_addr}/24"
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = "Shah Public Subnet" })

}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.shah_vpc.id
  cidr_block = "${var.shah_private_subnet_ip_addr}/24"
  tags       = merge(local.common_tags, { Name = "Shah Private Subnet" })

}

resource "aws_internet_gateway" "shah_igw" {
  vpc_id = aws_vpc.shah_vpc.id
  tags   = merge(local.common_tags, { Name = "Shah Internet Gateway" })

}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.shah_vpc.id
  route {
    cidr_block = "${var.shah_rt_ip_addr}/0"
    gateway_id = aws_internet_gateway.shah_igw.id
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id

}