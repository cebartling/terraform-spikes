# Setup the AWS provider | main.tf

terraform {
  required_version = "~> 0.14"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.28"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_named_profile
  shared_credentials_file = var.aws_shared_credentials_file
}

module "network" {
  source = "./modules/network"
  app_name = var.app_name
  app_environment = var.app_environment
}


//module "ecs-fargate-service" {
//  source = "cn-terraform/ecs-fargate-service/aws"
//  version = "2.0.12"
//  # insert the 10 required variables here
//  container_name = var.container_name
//  default_certificate_arn =
//  ecs_cluster_arn =
//  ecs_cluster_name =
//}

