resource "aws_s3_bucket" "tainted" {
  bucket = "my-tainted-bukcet-78978996989879807"
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"
}