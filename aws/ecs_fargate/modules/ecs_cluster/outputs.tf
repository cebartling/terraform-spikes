//# output ecs cluster public ip
//output "ecs_cluster_runner_ip" {
//  description = "External IP of ECS Cluster"
//  value       = [aws_instance.ecs-cluster-runner.*.public_ip]
//}

# Output ECS cluster ARN
output "ecs_cluster_arn" {
  description = "ECS Cluster ARN"
  value = aws_ecs_cluster.aws-ecs.arn
}

