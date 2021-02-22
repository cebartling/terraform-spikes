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

module "ecs" {
  source = "./modules/ecs"
  admin_sources_cidr_list = var.admin_sources_cidr_list
  app_environment = var.app_environment
  app_name = var.app_name
  aws_key_pair_name = var.aws_key_pair_name
  aws_region = var.aws_region
  aws_vpc_id = module.network.aws_vpc_id
  cluster_runner_count = var.cluster_runner_count
  cluster_runner_type = var.cluster_runner_type
  subnet_id = element(module.network.subnet_ids, 0)
  task_fargate_cpu = var.task_fargate_cpu
  task_fargate_memory = var.task_fargate_memory
  subnet_ids = module.network.subnet_ids
  datadog_access_key = var.datadog_access_key
  datadog_api_key = var.datadog_api_key
  datadog_private_key = var.datadog_private_key
  datadog_public_key_fingerprint = var.datadog_public_key_fingerprint
  datadog_public_key_pem = var.datadog_public_key_pem
  datadog_secret_access_key = var.datadog_secret_access_key
  datadog_site = var.datadog_site
}
