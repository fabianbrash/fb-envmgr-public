terraform {
  required_providers {
    rafay = {
      version = ">= 0.1"
      source = "registry.terraform.io/RafaySystems/rafay"
    }
    aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}