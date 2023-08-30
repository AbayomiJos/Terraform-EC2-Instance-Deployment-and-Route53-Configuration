## Creation of load balancer and target group

# Create load balancer
resource "aws_lb" "project_load_balancer" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]
}

# create target group for load balancer
resource "aws_lb_target_group" "my_target_group" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.project_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 10
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

}

# Create listener for port 80 that automatically redirects to port 443(HTTPS)
resource "aws_lb_listener" "my-listener" {
  load_balancer_arn = aws_lb.project_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

resource "aws_lb_listener" "my-listener-rule-HTTPS" {
  load_balancer_arn = aws_lb.project_load_balancer.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.ssl.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

## attach target group to load balancer

resource "aws_lb_target_group_attachment" "my-target-group-attachment" {
  for_each = aws_instance.server

  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = each.value.id
  port             = 80
}
