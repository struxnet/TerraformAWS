data "tls_certificate" "terraform_cloud" {
  url = "https://${var.terraform_cloud_hostname}"
}

resource "aws_iam_openid_connect_provider" "terraform_cloud" {
  client_id_list = [var.terraform_cloud_audience]
  tags = {
    Name = "Terraform Cloud"
  }
  tags_all = {
    Name = "Terraform Cloud"
  }
  thumbprint_list = [data.tls_certificate.terraform_cloud.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.terraform_cloud.url
}
