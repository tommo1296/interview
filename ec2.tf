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
}
