# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "aws-lb" {
  name = "${var.app_name}-load-balancer"
  description = "Controls access to the ALB"
  vpc_id = var.aws_vpc_id

  //  ingress {
  //    protocol    = "tcp"
  //    from_port   = var.nginx_app_port
  //    to_port     = var.nginx_app_port
  //    cidr_blocks = [var.app_sources_cidr]
  //  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.app_name}-load-balancer"
  }
}

# Traffic to the ECS cluster from the ALB
resource "aws_security_group" "aws-ecs-tasks" {
  name = "${var.app_name}-ecs-tasks"
  description = "Allow inbound access from the ALB only"
  vpc_id = var.aws_vpc_id

  //  ingress {
  //    protocol        = "tcp"
  //    from_port       = var.nginx_app_port
  //    to_port         = var.nginx_app_port
  //    security_groups = [aws_security_group.aws-lb.id]
  //  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.app_name}-ecs-tasks"
  }
}

# container template
data "template_file" "container_definitions" {
  template = file("./modules/ecs-fargate-service/container_definitions.json")

  vars = {
//    datadog_site = var.datadog_site
//    datadog_secret_access_key = var.datadog_secret_access_key
//    datadog_public_key_pem = var.datadog_public_key_pem
//    datadog_public_key_fingerprint = var.datadog_public_key_fingerprint
//    datadog_private_key = var.datadog_private_key
//    datadog_api_key = var.datadog_api_key
//    datadog_access_key = var.datadog_access_key
  }
}

# ECS task definition
resource "aws_ecs_task_definition" "private_location_worker_task" {
  family                   = "private-location-worker-task"
  execution_role_arn       = var.aws_iam_role_ecs_task_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_fargate_cpu
  memory                   = var.task_fargate_memory
  container_definitions    = data.template_file.container_definitions.rendered
}

//# ECS service
//resource "aws_ecs_service" "nginx_app" {
//  name            = var.nginx_app_name
//  cluster         = aws_ecs_cluster.aws-ecs.id
//  task_definition = aws_ecs_task_definition.nginx_app.arn
//  desired_count   = var.nginx_app_count
//  launch_type     = "FARGATE"
//
//  network_configuration {
//    security_groups  = [aws_security_group.aws-ecs-tasks.id]
//    subnets          = aws_subnet.aws-subnet.*.id
//    assign_public_ip = true
//  }
//
//  load_balancer {
//    target_group_arn = aws_alb_target_group.nginx_app.id
//    container_name   = var.nginx_app_name
//    container_port   = var.nginx_app_port
//  }
//
//  depends_on = [aws_alb_listener.front_end]
//
//  tags = {
//    Name = "${var.nginx_app_name}-nginx-ecs"
//  }
//}