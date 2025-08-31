resource "random_id" "bucket_suffix" {
  byte_length = 4
}
resource "aws_s3_bucket" "this" {
  count  = var.bucket_count
  bucket = "workspace-bucket-${terraform.workspace}-${random_id.bucket_suffix.hex}"
}