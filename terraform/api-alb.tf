# ALB for the web servers
resource "aws_lb" "api_servers" {
  name               = "api-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-securitygroup.id]
  subnets            = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  enable_http2       = false
  enable_cross_zone_load_balancing  = true

  tags = {
    Name = "api-alb"
  }
}

# Target group for the web servers
resource "aws_lb_target_group" "api_servers" {
  name     = "api-tg"
  port     = 5432
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  deregistration_delay = 300


  health_check {
    path = "/api/status"
    port = 5432
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  
  }
}

resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.api_servers.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_servers.arn
  }
}

resource "aws_security_group" "alb-securitygroup" {
  vpc_id = aws_vpc.main.id
  name = "alb-sg"
  description = "security group for application load balancer"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "api-alb"
  }
}


output "API-ALB" {
  value = aws_lb.api_servers.dns_name
}
