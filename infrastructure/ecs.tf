resource "aws_ecs_cluster" "testApp01" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "ecs_api" {
  name              = "/ecs/${var.app-stack}/api"
  retention_in_days = 30

  tags = {
    Name = "${var.app-stack}-api-logs"
  }
}

resource "aws_ecs_task_definition" "api" {
  family                   = "api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "${var.image}"
      essential = true

      portMappings = [
        {
          containerPort = var.api_port
          hostPort      = var.api_port
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.app-stack}/api"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "api"
        }
      }
    }
  ])
}

resource "aws_ecr_repository" "ecr_repo" {
  name                 = "test-repo"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
}

resource "aws_ecr_lifecycle_policy" "name" {
  repository = aws_ecr_repository.ecr_repo.name
  policy     = file("${path.module}/../api/policy.json")
}

resource "aws_ecr_registry_scanning_configuration" "scan_configuration" {
  scan_type = "ENHANCED"

  rule {
    scan_frequency = "CONTINUOUS_SCAN"
    repository_filter {
      filter      = "*"
      filter_type = "WILDCARD"
    }
  }
}
resource "aws_ecs_service" "api_service" {
  name            = "api-service"
  cluster         = aws_ecs_cluster.testApp01.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.service_target_group.arn
    container_name   = var.container_name
    container_port   = var.api_port
  }
  depends_on = [aws_lb_listener.alb_default_listener_https]
  network_configuration {
    subnets         = aws_subnet.private[*].id
    security_groups = [aws_security_group.ecs_sg.id]
  }
}
