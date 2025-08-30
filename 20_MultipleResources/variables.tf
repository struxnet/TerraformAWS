variable "multiple_ec2" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}
variable "subnet_config" {
  description = "Subnet configuration"
  type = map(object({
    cidr_block = string
  }))

  validation {
    condition = alltrue([
      for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
    ])
    error_message = "At least one of the provided CIDR blocks is not valid."
  }
}

variable "ec2_instance_config_list" {
  type = list(object({
    instance_type = string
    ami           = string
  }))
  # Ensure that only t2.micro is used
  # 1. Map from the object to instance_type
  # 2. Map from the instance_type to a boolean indicating whether it is "t2.micro"
  # 3. Check the list of booleans contains only true values.

  validation {
    condition = alltrue([
      for instance_config in var.ec2_instance_config_list : contains(["t2.micro"], instance_config.instance_type)
    ])
    error_message = "Only t2.micro and ubuntu and nginx ami are allowed for instances."
  }
}

variable "ec2_instance_config_map" {
  type = map(object({
    instance_type = string
    ami           = string
    subnet_name   = optional(string, "default")
  }))
  validation {
    condition = alltrue([
      for instance_config in values(var.ec2_instance_config_map) : contains(["t2.micro"], instance_config.instance_type)
    ])
    error_message = "Only t2.micro and ubuntu and nginx ami are allowed for instances."
  }
  validation {
    condition = alltrue([
      for instance_config in values(var.ec2_instance_config_map) : contains(["nginx", "ubuntu"], instance_config.ami)
    ])
    error_message = "Only t2.micro and ubuntu and nginx ami are allowed for instances."
  }
}


