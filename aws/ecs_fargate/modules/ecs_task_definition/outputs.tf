# Output ECS task definition ARN
output "task_definition_arn" {
  description = "ECS task definition ARN"
  value = aws_ecs_task_definition.service.arn
}

