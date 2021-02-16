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

module "ecs_cluster" {
  source = "./modules/ecs_cluster"
  admin_sources_cidr_list = var.admin_sources_cidr_list
  app_environment = var.app_environment
  app_name = var.app_name
  aws_key_pair_name = var.aws_key_pair_name
  aws_region = var.aws_region
  aws_vpc_id = module.network.aws_vpc_id
  cluster_runner_count = var.cluster_runner_count
  cluster_runner_type = var.cluster_runner_type
  subnet_id = module.network.aws_subnet_id
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

