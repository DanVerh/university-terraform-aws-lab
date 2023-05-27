terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
  required_version = ">= 1.2.3"

  backend "s3" {
    bucket         = "lpnu-cloudtech-state" #place your bucket name for state here
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}