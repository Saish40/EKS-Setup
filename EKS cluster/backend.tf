terraform {
  backend "s3" {
    bucket = "eks-terraform-module"
    key    = "setup/terraform.tfstate"
    region = "us-east-1"
  }
}