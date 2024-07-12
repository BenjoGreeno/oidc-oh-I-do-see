resource "aws_lb" "ecs_lb" {
  name                             = "ecs-lb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.lb_sg.id]
  subnets                          = aws_subnet.public[*].id
  enable_cross_zone_load_balancing = "true"
}

resource "aws_lb_target_group" "service_target_group" {
  name                 = "${var.app-stack}-TargetGroup-${var.environment}"
  port                 = var.api_port
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = aws_vpc.testApp01-vpc.id
  deregistration_delay = 5

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    matcher             = var.healthcheck_matcher
    path                = var.healthcheck_endpoint
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 30
  }

  depends_on = [aws_lb.ecs_lb]
}

resource "aws_lb_listener" "alb_default_listener_https" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.wildcard-lb.arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Access denied"
      status_code  = "403"
    }
  }

  depends_on = [aws_acm_certificate.wildcard-lb]
}

resource "aws_lb_listener_rule" "https_listener_rule" {
  listener_arn = aws_lb_listener.alb_default_listener_https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_target_group.arn
  }

  condition {
    host_header {
      values = ["${var.domain_alb}"]
    }
  }
}