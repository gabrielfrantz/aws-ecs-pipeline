terraform {
  required_version = ">=1.9.4" #versão do terraform

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "nome-bucket"
    key    = "aws/terraform.tfstate"
    region = "sa-east-1"
  }
}

provider "aws" {
  region = "sa-east-1"
  default_tags {
    tags = {
      owner      = "Owner"
      manager-by = "Admin"
    }
  }
}