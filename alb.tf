resource "aws_security_group" "public_alb_sg" {
  name    = "public-alb-sg"
  vpc_id  = aws_vpc.interview_vpc.id

  ingress {
    description   = "http"
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "public_alb" {
  name              = "public-alb"
  internal          = false
  subnets           = aws_subnet.interview_public_subnets.*.id
  security_groups   = [aws_security_group.public_alb_sg.id]
}

resource "aws_lb_listener" "public_alb_http_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Nothing to see here"
      status_code = "404"
    }
  }
}
