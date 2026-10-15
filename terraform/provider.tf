terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
  }
}

provider "aws" {

  default_tags {
    tags = {
      Environment = "Production"
      Project     = "Cloud Resume"
      CreatedBy   = "Ivan"
      ManagedBy   = "Terraform"
    }
  }

}
