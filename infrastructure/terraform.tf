terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.57.0"
    }
  }
  cloud {
    organization = "benjo-learns"

    workspaces {
      name = "ECS-Mess"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
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

# terraform {
#   cloud {
#     organization = "benjo-learns"

#     workspaces {
#       name = "ECS-Mess"
#     }
#   }
# }