# output ecs cluster public ip
output "aws_vpc_id" {
  description = "VPC ID"
  value = aws_vpc.aws-vpc.id
}

output "aws_subnet_id" {
  value = element(aws_subnet.aws-subnet.*.id, 0)
}

output "private_subnet_id_list" {
  value = []
}

output "public_subnet_id_list" {
  value = [aws_subnet.aws-subnet.*.id]
}
