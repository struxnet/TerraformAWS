terraform {
  cloud {

    organization = "Shah-Ammar-Terraform"

    workspaces {
      name = "terraform-cli"
    }
  }

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}