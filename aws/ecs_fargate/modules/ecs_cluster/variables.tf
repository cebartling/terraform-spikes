variable "app_name" {
  type = string
  description = "Application name"
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

variable "admin_sources_cidr" {
  type = string
}