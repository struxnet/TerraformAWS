variable "terraform_cloud_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname for Terraform Cloud"
}

variable "terraform_cloud_audience" {
  type        = string
  default     = "aws.workload.identity"
  description = "The audience for Terraform Cloud to authenticate"
}
