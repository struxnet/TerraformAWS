terraform {
  backend "s3" {
    bucket       = "shah-terraform-state-bucket-aws"
    key          = "06-backends/state.tfstate"
    region       = "us-west-1"
    use_lockfile = true
    encrypt      = true
  }
}