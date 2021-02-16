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

  // Recreates the ALLOW ALL rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-load-balancer"
  }
}

# Traffic to the ECS cluster from the ALB
resource "aws_security_group" "aws-ecs-tasks" {
  name = "${var.app_name}-ecs-tasks"
  description = "Allow outbound access from the ALB only"
  vpc_id = var.aws_vpc_id

  //  ingress {
  //    protocol        = "tcp"
  //    from_port       = var.nginx_app_port
  //    to_port         = var.nginx_app_port
  //    security_groups = [aws_security_group.aws-lb.id]
  //  }

  // Recreates the ALLOW ALL rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-ecs-tasks"
  }
}

# container template
data "template_file" "container_definitions" {
  template = file("./modules/ecs-fargate-service/container_definitions.json")
}

# ECS task definition
resource "aws_ecs_task_definition" "private_location_worker_task" {
  family                   = "private-location-worker-task"
  execution_role_arn       = var.aws_iam_role_ecs_task_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = var.task_fargate_cpu
  memory                   = var.task_fargate_memory
  container_definitions    = data.template_file.container_definitions.rendered
}

# ECS service
resource "aws_ecs_service" "private_location_worker_app" {
  name            = var.app_name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.private_location_worker_task.arn
  desired_count   = var.private_location_worker_instance_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.aws-ecs-tasks.id]
    subnets          = var.subnet_id_list
    assign_public_ip = false
  }

//  load_balancer {
//    target_group_arn = aws_alb_target_group.nginx_app.id
//    container_name   = var.nginx_app_name
//    container_port   = var.nginx_app_port
//  }

//  depends_on = [aws_alb_listener.front_end]

  tags = {
    Name = "${var.app_name}-ecs-service"
  }
}