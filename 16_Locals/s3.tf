resource "aws_s3_bucket" "project_bucket" {
  bucket = "${local.project_name}-bucket-${random_id.bucket_id.hex}"

  tags = merge(local.common_tags, var.additional_tags)

}