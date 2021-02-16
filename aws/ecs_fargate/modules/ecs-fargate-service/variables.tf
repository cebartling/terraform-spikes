variable "app_name" {
  type = string
  description = "Application name"
}

variable "aws_vpc_id" {
  type = string
}

variable "aws_iam_role_ecs_task_execution_role_arn" {
  type = string
}

variable "task_fargate_cpu" {
  type = number
}

variable "task_fargate_memory" {
  type = number
}


//# override ECS AMI image
//variable "aws_ecs_ami_override" {
//  type = string
//  default = ""
//  description = "Machine image to use for ec2 instances"
//}
//
//variable "aws_region" {
//  type = string
//  description = "AWS region where everything is being provisioned"
//}
//
//variable "cluster_runner_type" {
//  type = string
//}
//
//variable "aws_key_pair_name" {
//  type = string
//}
//
//variable "cluster_runner_count" {
//  type = number
//}
//
//variable "app_environment" {
//  type = string
//}
//
//
//variable "admin_sources_cidr_list" {
//  type = list(string)
//}
//
//variable "subnet_id" {
//  type = string
//}

//variable "nginx_app_count" {
//  description = "Number of Docker containers to run"
//  default     = 2
//}
//
//variable "nginx_fargate_cpu" {
//  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
//  default     = "1024"
//}
//
//variable "nginx_fargate_memory" {
//  description = "Fargate instance memory to provision (in MiB)"
//  default     = "2048"
//}
