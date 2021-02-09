resource "aws_vpc" "interview_vpc" {
  cidr_block = "192.168.128.0/24"

  tags = {
    Name = "interview-vpc"
  }
}
