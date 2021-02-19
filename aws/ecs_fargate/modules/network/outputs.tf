# output ecs cluster public ip
output "aws_vpc_id" {
  description = "VPC ID"
  value = aws_vpc.vpc.id
}

output "subnet_ids" {
  value = aws_subnet.subnets.*.id
}
