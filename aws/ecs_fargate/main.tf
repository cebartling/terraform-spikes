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

module "ecs-task-definition" {
  source = "./modules/ecs_task_definition"
}

module "ecs-fargate-service" {
//  source = "cn-terraform/ecs-fargate-service/aws"
//  version = "2.0.12"
//  container_name = var.container_name
//  ecs_cluster_arn = module.ecs_cluster.ecs_cluster_arn
//  ecs_cluster_name = module.ecs_cluster.ecs_cluster_name
//  name_prefix = var.ecs_fargate_service_name_prefix
//  private_subnets = module.network.private_subnet_id_list
//  public_subnets = element(module.network.public_subnet_id_list, 0)
//  task_definition_arn = module.ecs-task-definition.task_definition_arn
//  vpc_id = module.network.aws_vpc_id
//  assign_public_ip = false
}

