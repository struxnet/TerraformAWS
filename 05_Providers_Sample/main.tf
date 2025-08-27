resource "random_id" "bucket_suffix" {
  byte_length = 6
}

resource "aws_s3_bucket" "shah_bucket" {
  bucket = "shah-bucket-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket" "shah_bucket_provider" {
  bucket = "shah-bucket-${random_id.bucket_suffix.hex}"
  provider = aws.us-east-1
}

output "bucket_name" {
  value = aws_s3_bucket.shah_bucket.bucket
}