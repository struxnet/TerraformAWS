variable "aws_region" {
  type    = string
  default = "us-west-1"

}

variable "instance_size" {
  type        = string
  default     = "t3.micro"
  description = "The size of your selected EC2 instances"
  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_size)
    error_message = "Invalid instance size. Allowed values are: t2.micro, t3.micro, t3.small, t3.medium"
  }
}

variable "volume_config" {
  type = object({
    size = number
    type = string
  })
  description = "Configuration settings for the volume"
  default = {
    size = 10
    type = "gp3"
  }
}

variable "volume_config_map" {
  type        = map(string)
  description = "Configuration settings for the volume"
  default = {
    size = "10"
    type = "gp3"
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags to assign to the resources"
  default = {
    Environment = "Dev"
    Team        = "Platform"
  }
}