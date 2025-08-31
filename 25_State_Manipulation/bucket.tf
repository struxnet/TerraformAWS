# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "shah-terraform-state-bucket-aws"
resource "aws_s3_bucket_public_access_block" "remote_state" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = "shah-terraform-state-bucket-aws"
  ignore_public_acls      = true
  region                  = "us-west-1"
  restrict_public_buckets = true
  skip_destroy            = null
}
