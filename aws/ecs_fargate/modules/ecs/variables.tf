variable "app_name" {
  type = string
  description = "Application name"
}

# override ECS AMI image
variable "aws_ecs_ami_override" {
  type = string
  default = ""
  description = "Machine image to use for ec2 instances"
}

variable "aws_region" {
  type = string
  description = "AWS region where everything is being provisioned"
}

variable "cluster_runner_type" {
  type = string
}

variable "aws_key_pair_name" {
  type = string
}

variable "cluster_runner_count" {
  type = number
}

variable "app_environment" {
  type = string
}

variable "aws_vpc_id" {
  type = string
}

variable "admin_sources_cidr_list" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "task_fargate_cpu" {
  type = number
}

variable "task_fargate_memory" {
  type = number
}

variable "private_location_worker_instance_count" {
  type = number
  default = 1
}

variable "subnet_ids" {
  type = list(string)
}


