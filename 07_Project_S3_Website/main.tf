locals {
  mime_types = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".ico"  = "image/vnd.microsoft.icon"
    ".jpeg" = "image/jpeg"
    ".png"  = "image/png"
    ".svg"  = "image/svg+xml"
  }
}
resource "random_id" "bucket_suffix" {
  byte_length = 4

}

resource "aws_s3_bucket" "shah_website" {
  bucket = "terraform-shah-statis-website-${random_id.bucket_suffix.hex}"

}
resource "aws_s3_bucket_ownership_controls" "shah_website" {
  bucket = aws_s3_bucket.shah_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "shah_acl" {
  depends_on = [aws_s3_bucket_public_access_block.shah_website, aws_s3_bucket_ownership_controls.shah_website, ]
  bucket     = aws_s3_bucket.shah_website.id
  acl        = "public-read"

}

resource "aws_s3_bucket_public_access_block" "shah_website" {
  bucket                  = aws_s3_bucket.shah_website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}

resource "aws_s3_bucket_policy" "shah_website_public_read" {
  bucket = aws_s3_bucket.shah_website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.shah_website.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.shah_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.shah_website.id
  for_each     = fileset("static_website/", "**")
  key          = each.value
  source       = "static_website/${each.value}"
  etag         = filemd5("static_website/${each.value}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
}
