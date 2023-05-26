terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
  required_version = ">= 1.2.3"

  backend "s3" {
    bucket         = "verkhutin-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}