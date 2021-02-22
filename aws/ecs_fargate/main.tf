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


data "aws_kms_key" "ssm" {
  key_id = "alias/aws/ssm"
}

resource "aws_ssm_parameter" "datadog_api_key" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/api_key"
  type   = "SecureString"
  value  = var.datadog_api_key
  key_id = data.aws_kms_key.ssm.arn
}

resource "aws_ssm_parameter" "datadog_site" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/site"
  type   = "SecureString"
  value  = var.datadog_site
  key_id = data.aws_kms_key.ssm.arn
}

resource "aws_ssm_parameter" "datadog_access_key" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/access_key"
  type   = "SecureString"
  value  = var.datadog_access_key
  key_id = data.aws_kms_key.ssm.arn
}

resource "aws_ssm_parameter" "datadog_secret_access_key" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/secret_access_key"
  type   = "SecureString"
  value  = var.datadog_secret_access_key
  key_id = data.aws_kms_key.ssm.arn
}

resource "aws_ssm_parameter" "datadog_private_key" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/private_key"
  type   = "SecureString"
  value  = var.datadog_private_key
  key_id = data.aws_kms_key.ssm.arn
}

resource "aws_ssm_parameter" "datadog_public_key_pem" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/public_key_pem"
  type   = "SecureString"
  value  = var.datadog_public_key_pem
  key_id = data.aws_kms_key.ssm.arn
}

resource "aws_ssm_parameter" "datadog_public_key_fingerprint" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/public_key_fingerprint"
  type   = "SecureString"
  value  = var.datadog_public_key_fingerprint
  key_id = data.aws_kms_key.ssm.arn
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
}
