terraform {
  backend "s3" {
    bucket       = "shah-terraform-state-bucket"
    key          = "04-backends/state.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}