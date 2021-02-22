//data "template_file" "container_definitions" {
//  template = file("./modules/ecs/container_definitions.json")
//}

data "template_file" "cluster_user_data_shell_script" {
  template = file("modules/ecs/cluster_user_data.sh")
  vars = {
    ecs_cluster = aws_ecs_cluster.private_locations.name
  }
}

data "aws_iam_policy_document" "private_locations" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "task_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

data "aws_ami" "private_locations" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "amzn2-ami-ecs-hvm-2.0.*"
    ]
  }

  filter {
    name = "architecture"
    values = [
      "x86_64"
    ]
  }

  owners = [
    "amazon"
  ]
}

data "aws_kms_key" "ssm" {
  key_id = "alias/aws/ssm"
}


locals {
  aws_ecs_ami = var.aws_ecs_ami_override == "" ? data.aws_ami.private_locations.id : var.aws_ecs_ami_override
}

resource "aws_ssm_parameter" "datadog_api_key" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/api_key"
  type   = "SecureString"
  value  = var.datadog_api_key
  key_id = data.aws_kms_key.ssm.arn
}

resource "aws_ssm_parameter" "datadog_site" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/site"
  type   = "SecureString"
  value  = var.datadog_site
  key_id = data.aws_kms_key.ssm.arn
}

resource "aws_ssm_parameter" "datadog_access_key" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/access_key"
  type   = "SecureString"
  value  = var.datadog_access_key
  key_id = data.aws_kms_key.ssm.arn
}

resource "aws_ssm_parameter" "datadog_secret_access_key" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/secret_access_key"
  type   = "SecureString"
  value  = var.datadog_secret_access_key
  key_id = data.aws_kms_key.ssm.arn
}

resource "aws_ssm_parameter" "datadog_private_key" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/private_key"
  type   = "SecureString"
  value  = var.datadog_private_key
  key_id = data.aws_kms_key.ssm.arn
}

resource "aws_ssm_parameter" "datadog_public_key_pem" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/public_key_pem"
  type   = "SecureString"
  value  = var.datadog_public_key_pem
  key_id = data.aws_kms_key.ssm.arn
}

resource "aws_ssm_parameter" "datadog_public_key_fingerprint" {
  name   = "/${var.app_name}-${var.app_environment}/datadog/public_key_fingerprint"
  type   = "SecureString"
  value  = var.datadog_public_key_fingerprint
  key_id = data.aws_kms_key.ssm.arn
}

resource "aws_ecs_cluster" "private_locations" {
  name = var.app_name
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.app_name}-ecsInstanceRole"
  assume_role_policy = data.aws_iam_policy_document.private_locations.json
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
  role = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_role" {
  name = "${var.app_name}-ecsInstanceRole"
  role = aws_iam_role.ecs_instance_role.name
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.app_name}-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_cluster_runner_role" {
  name = "${var.app_name}-ecs-cluster-runner-role"
  assume_role_policy = data.aws_iam_policy_document.private_locations.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ecs_cluster_runner_policy" {
  statement {
    actions = [
      "ec2:Describe*",
      "ecr:Describe*",
      "ecr:BatchGet*"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "ecs:*"
    ]
    resources = [
      "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:service/${var.app_name}/*"
    ]
  }
}

resource "aws_iam_role_policy" "ecs_cluster_runner" {
  name = "${var.app_name}-ecs-cluster-runner-policy"
  role = aws_iam_role.ecs_cluster_runner_role.name
  policy = data.aws_iam_policy_document.ecs_cluster_runner_policy.json
}

resource "aws_iam_instance_profile" "ecs_cluster_runner" {
  name = "${var.app_name}-ecs-cluster-runner-iam-profile"
  role = aws_iam_role.ecs_cluster_runner_role.name
}

resource "aws_instance" "ecs_cluster_runner" {
  ami = local.aws_ecs_ami
  instance_type = var.cluster_runner_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [
    aws_security_group.ecs_cluster_host.id
  ]
  associate_public_ip_address = true
  key_name = var.aws_key_pair_name
  user_data = data.template_file.cluster_user_data_shell_script.rendered
  count = var.cluster_runner_count
  iam_instance_profile = aws_iam_instance_profile.ecs_cluster_runner.name

  tags = {
    Name = "${var.app_name}-ecs-cluster-runner"
    Environment = var.app_environment
    Role = "ecs-cluster"
  }

  volume_tags = {
    Name = "${var.app_name}-ecs-cluster-runner"
    Environment = var.app_environment
    Role = "ecs-cluster"
  }
}

resource "aws_security_group" "ecs_cluster_host" {
  name = "${var.app_name}-ecs-cluster-host"
  description = "${var.app_name}-ecs-cluster-host"
  vpc_id = var.aws_vpc_id
  tags = {
    Name = "${var.app_name}-ecs-cluster-host"
    Environment = var.app_environment
    Role = "ecs-cluster"
  }
}

resource "aws_security_group_rule" "ingress_ssh" {
  security_group_id = aws_security_group.ecs_cluster_host.id
  description = "Admin SSH access to ECS cluster"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = var.admin_sources_cidr_list
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.ecs_cluster_host.id
  description = "ECS cluster egress"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "load_balancer" {
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
resource "aws_security_group" "ecs_tasks" {
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

resource "aws_ecs_task_definition" "private_locations" {
  family                   = "private-locations-worker-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = var.task_fargate_cpu
  memory                   = var.task_fargate_memory
  container_definitions = templatefile("${path.module}/container_definitions.json", {
    account_id                      = data.aws_caller_identity.current.account_id
    datadog_site                    = aws_ssm_parameter.datadog_site.value
    datadog_secret_access_key       = aws_ssm_parameter.datadog_secret_access_key.value
    datadog_public_key_pem          = aws_ssm_parameter.datadog_public_key_pem.value
    datadog_public_key_fingerprint  = aws_ssm_parameter.datadog_public_key_fingerprint.value
    datadog_private_key             = aws_ssm_parameter.datadog_private_key.value
    datadog_api_key                 = aws_ssm_parameter.datadog_api_key.value
    datadog_access_key              = aws_ssm_parameter.datadog_access_key.value
  })
}

resource "aws_ecs_service" "private_locations" {
  name            = var.app_name
  cluster         = aws_ecs_cluster.private_locations.id
  task_definition = aws_ecs_task_definition.private_locations.arn
  desired_count   = var.private_location_worker_instance_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.subnet_ids
    assign_public_ip = true
  }

  tags = {
    Name = "${var.app_name}-ecs-service"
  }
}
