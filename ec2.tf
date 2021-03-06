resource "aws_security_group" "interview_web_sg" {
  name    = "interview-web-sg"
  vpc_id  = aws_vpc.interview_vpc.id

  ingress {
    description   = "http"
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = local.public_subnets
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "interview_web" {
  count = length(local.private_subnets)

  instance_type = "t2.micro"
  ami           = "ami-098828924dc89ea4a" # amazon linux 2 - ideally be a data variable

  availability_zone       = element(local.azs, count.index)
  subnet_id               = element(aws_subnet.interview_private_subnets.*.id, count.index)
  vpc_security_group_ids  = [aws_security_group.interview_web_sg.id]

  user_data = file("install_nginx.sh")

  tags = {
    Name = "interview-web-${element(local.azs, count.index)}"
  }

  depends_on = [aws_nat_gateway.interview_nat_gw]
}

resource "aws_lb_target_group" "interview_web_tg" {
  name      = "interview-web-tg"
  port      = 80
  protocol  = "HTTP"
  vpc_id    = aws_vpc.interview_vpc.id
}

resource "aws_lb_target_group_attachment" "interview_web_tg_instances" {
  count = length(aws_instance.interview_web)

  target_group_arn  = aws_lb_target_group.interview_web_tg.arn
  target_id         = element(aws_instance.interview_web.*.id, count.index)
  port              = 80
}

resource "aws_lb_listener_rule" "interview_web_listener_rule" {
  listener_arn = aws_lb_listener.public_alb_http_listener.arn

  action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.interview_web_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
