# providers.tf

terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74.0"
    }
  }

  backend "s3" {
    bucket = "pgr301-2024-terraform-state"  # Bucket for lagring av Terraform state
    key    = "infra/terraform.tfstate"       # Filsti for state-filen i bucketen
    region = "eu-west-1"                     # Region for S3-bucketen
  }
}

provider "aws" {
  region = "eu-west-1"  # Region hvor ressursene skal opprettes
}
