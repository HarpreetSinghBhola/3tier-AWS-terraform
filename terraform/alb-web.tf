# ALB for the web servers
resource "aws_lb" "web_servers" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-securitygroup.id]
  subnets            = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  enable_http2       = false
  enable_cross_zone_load_balancing  = true

  tags = {
    Name = "web-alb"
  }
}

# Target group for the web servers
resource "aws_lb_target_group" "web_servers" {
  name     = "web-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  deregistration_delay = 300


  health_check {
    path = "/"
    port = 8080
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  
  }
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web_servers.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_servers.arn
  }
}

output "WEB-ALB" {
  value = aws_lb.web_servers.dns_name
}
