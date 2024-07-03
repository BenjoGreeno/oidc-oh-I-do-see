terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.56.1"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Owner      = "Ben"
      OwnerEmail = "iamben84@gmail.com"
      AppStackID = "testApp01"
    }
  }
}

provider "aws" {
  alias  = "cdn"
  region = "us-east-1"
}