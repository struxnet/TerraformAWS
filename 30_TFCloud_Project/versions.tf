terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"

    }
  }


  cloud {

    organization = "Shah-Ammar-Terraform"

    workspaces {
      name = "terraform-cli"
    }
  }


}

provider "aws" {
  region = "us-west-1"
}