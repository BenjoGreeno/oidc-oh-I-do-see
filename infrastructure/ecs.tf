resource "aws_ecs_cluster" "testApp01" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "api" {
  family                   = "api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "api-container"
      image     = "${var.image}"
      essential = true

      portMappings = [
        {
          containerPort = var.api_port
          hostPort      = var.api_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "api_service" {
  name            = "api-service"
  cluster         = aws_ecs_cluster.testApp01.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.service_target_group.arn
    container_name   = "api-container"
    container_port   = var.api_port
  }
  depends_on = [ aws_lb_listener.alb_default_listener_https ]
  network_configuration {
    subnets         = aws_subnet.private[*].id
    security_groups = [aws_security_group.ecs_sg.id]
  }
}
