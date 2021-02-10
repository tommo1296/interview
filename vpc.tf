resource "aws_vpc" "interview_vpc" {
  cidr_block = "192.168.128.0/24"

  tags = {
    Name = "interview-vpc"
  }
}

resource "aws_subnet" "interview_public_subnets" {
  count = length(local.public_subnets)

  cidr_block                = element(local.public_subnets, count.index)
  vpc_id                    = aws_vpc.interview_vpc.id
  availability_zone         = element(local.azs, count.index)
  map_public_ip_on_launch   = true

  tags = {
    Name = "interview-public-subnet-${element(local.azs, count.index)}"
    Type = "Public"
  }
}

resource "aws_internet_gateway" "interview_igw" {
  vpc_id = aws_vpc.interview_vpc.id

  tags = {
    Name = "interview-igw"
  }
}

resource "aws_route_table" "interview_igw_rtb" {
  vpc_id = aws_vpc.interview_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.interview_igw.id
  }

  tags = {
    Name = "internet-igw-rtb"
  }
}

resource "aws_route_table_association" "interview_public_subnets" {
  count = length(local.public_subnets)

  subnet_id       = element(aws_subnet.interview_public_subnets.*.id, count.index)
  route_table_id  = aws_route_table.interview_igw_rtb.id
}
