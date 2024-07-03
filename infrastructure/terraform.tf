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
      Owner      = "${var.owner}"
      OwnerEmail = "${var.owner-email}"
      AppStackID = "${var.app-stack}"
    }
  }
}

provider "aws" {
  alias  = "cdn"
  region = "us-east-1"
}