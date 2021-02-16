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

variable "ecs_cluster_id" {
  type = string
}

variable "private_location_worker_instance_count" {
  type = number
  default = 1
}

variable "subnet_id_list" {
  type = list(string)
}
