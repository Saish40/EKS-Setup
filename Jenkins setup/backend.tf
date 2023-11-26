terraform {
  backend "s3" {
    bucket = "eks-terraform-module"
    region = "us-east-1"
    key    = "terraform.tfstate"
  }
}