resource "aws_s3_bucket" "this" {
  bucket = "tf-cloud-bucket-0987890987890"

  tags = {
    CreatedBy = "Terraform Cloud"
  }

}