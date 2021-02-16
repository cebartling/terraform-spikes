

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


//variable "container_name" {
//  type = string
//  description = "Name of the running container"
//}


//default_certificate_arn string
//Description: (Optional) The ARN of the default SSL server certificate. Required if var.https_ports is set.
//ecs_cluster_arn string
//Description: ARN of an ECS cluster
//ecs_cluster_name string
//Description: (Optional) Name of the ECS cluster. Required only if autoscaling is enabled
//name_prefix string
//Description: Name prefix for resources on AWS
//private_subnets list(any)
//Description: The private subnets associated with the task or service.
//public_subnets list(any)
//Description: The public subnets associated with the task or service.
//ssl_policy string
//Description: (Optional) The name of the SSL Policy for the listener. . Required if var.https_ports is set.
//task_definition_arn
//
//
//task_definition_arn string
//Description: (Required) The full ARN of the task definition that you want to run in your service.
//vpc_id string
//Description: ID of the VPC



