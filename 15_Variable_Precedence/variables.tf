variable "aws_region" {
  type    = string
  default = "us-west-1"

}

variable "instance_size" {
  type        = string
  default     = "t3.micro"
  description = "The size of your selected EC2 instances"
  validation {
    condition     = startswith(var.instance_size, "t3")
    error_message = "Only supports T3 family."
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