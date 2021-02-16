

variable "aws_region" {
  type = string
  description = "AWS region to use"
}

variable "aws_named_profile" {
  type = string
  description = "AWS named profile"
}

variable "aws_shared_credentials_file" {
  type = string
  description = "AWS credentials file"
}

variable "app_name" {
  type = string
  description = "Name of the application"
}

variable "app_environment" {
  type = string
}

variable "admin_sources_cidr_list" {
  type        = list(string)
  description = "IPv4 CIDR block from which to allow admin access"
}

variable "app_sources_cidr_list" {
  type        = list(string)
  description = "List of IPv4 CIDR blocks from which to allow application access"
}

variable "aws_key_pair_name" {
  type = string
}

variable "aws_key_pair_file" {
  type = string
}

variable "cluster_runner_type" {
  type        = string
  description = "EC2 instance type of ECS Cluster Runner"
  default     = "t3.medium"
}

variable "cluster_runner_count" {
  type        = string
  description = "Number of EC2 instances for ECS Cluster Runner"
  default     = "1"
}

variable "container_name" {
  type = string
  description = "Name of the running container"
}

variable "ecs_fargate_service_name_prefix" {
  type = string
  description = "Name prefix for resources on AWS"
}

//variable "datadog_site" {
//  type = string
//}
//
//variable "datadog_access_key" {
//  type = string
//}
//
//variable "datadog_api_key" {
//  type = string
//}
//
//variable "datadog_secret_access_key" {
//  type = string
//}
//
//variable "datadog_private_key" {
//  type = string
//}
//
//variable "datadog_public_key_pem" {
//  type = string
//}
//
//variable "datadog_public_key_fingerprint" {
//  type = string
//}

variable "task_fargate_cpu" {
  type = number
}

variable "task_fargate_memory" {
  type = number
}


