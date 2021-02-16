# output ecs cluster public ip
output "aws_vpc_id" {
  description = "VPC ID"
  value       = [aws_vpc.aws-vpc.id]
}
