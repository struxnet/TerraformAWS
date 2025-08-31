variable "ec2_instance_type" {
  description = "EC2 instance type"
  type = string

  validation {
    condition     = var.ec2_instance_type == "t2.micro"
    error_message = "EC2 instance type must be t2.micro"
  }
}