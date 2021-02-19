//# output ecs cluster public ip
//output "ecs_cluster_runner_ip" {
//  description = "External IP of ECS Cluster"
//  value       = [aws_instance.ecs-cluster-runner.*.public_ip]
//}

# Output ECS cluster ARN
//output "ecs_cluster_arn" {
//  description = "ECS Cluster ARN"
//  value = aws_ecs_cluster.aws-ecs.arn
//}
//
//output "ecs_cluster_id" {
//  value = aws_ecs_cluster.aws-ecs.id
//}
//
//output "ecs_cluster_name" {
//  description = "ECS cluster name"
//  value = aws_ecs_cluster.aws-ecs.name
//}
//
//output "aws_iam_role_ecs_task_execution_role_arn" {
//  value = aws_iam_role.ecsTaskExecutionRole.arn
//}