variable "region" {
  default = "eu-west-1"
}

variable "ecs_cluster_name" {
  default = "testApp01-ecs-cluster"
}

variable "ecr-repo" {
  description = "name of ecr repo"
  type        = string
  default     = "test-repo"

}

variable "container_name" {
  description = "container name the backend is running on"
  type        = string
  default     = "test-container"

}

variable "vpc_cidr" {
  description = "vpc subnet range"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.0.0/20"
}

variable "private_subnet_cidr" {
  default = "10.0.16.0/20"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "api_port" {
  default = 8000
}

variable "app-stack" {
  description = ""
  default     = "testApp01"
  type        = string
}

variable "hosted_zone" {
  description = "this assumes you have a hosted zone set up, please provide it"
  type        = string
  default     = "bengreen.xyz"
}

variable "domain_cloudfront" {
  description = "this will try and create an A record under the specified hosted zone"
  type        = string
  default     = "hello-from.bengreen.xyz"
}

variable "domain_alb" {
  description = "this will try and create an A record under the specified hosted zone"
  type        = string
  default     = "backend.bengreen.xyz"
}

variable "environment" {
  description = "which environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC network"
  default     = "10.0.0.0/16"
  type        = string
}

variable "az_count" {
  description = "Describes how many availability zones are used"
  default     = 3
  type        = number
}
variable "custom_origin_host_header" {
  description = "Custom header to ensure communication only through CloudFront"
  default     = "Demo123"
  type        = string
}

variable "healthcheck_endpoint" {
  description = "Endpoint for ALB healthcheck"
  type        = string
  default     = "/"
}

variable "healthcheck_matcher" {
  description = "HTTP status code matcher for healthcheck"
  type        = string
  default     = "200"
}

variable "owner" {
  description = "for default tags"
  type        = string
  default     = "Ben"
}

variable "owner-email" {
  description = "for default tags"
  type        = string
  default     = "iamben84@gmail.com"
}

variable "image" {
  description = "docker image to test the back end"
  type        = string
  default     = "906273274991.dkr.ecr.eu-west-1.amazonaws.com/test-repo:fast-api-2024-07-03"
}
