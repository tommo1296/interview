resource "aws_vpc" "interview_vpc" {
  cidr_block = "192.168.128.0/24"

  tags = {
    Name = "interview-vpc"
  }
}

resource "aws_subnet" "interview_public_subnet_a" {
  cidr_block                = "192.168.128.0/28"
  vpc_id                    = aws_vpc.interview_vpc.id
  availability_zone         = "eu-west-2a"
  map_public_ip_on_launch   = true

  tags = {
    Name = "interview-public-subnet-a"
    Type = "Public"
  }
}

resource "aws_subnet" "interview_public_subnet_b" {
  cidr_block                = "192.168.128.16/28"
  vpc_id                    = aws_vpc.interview_vpc.id
  availability_zone         = "eu-west-2b"
  map_public_ip_on_launch   = true

  tags = {
    Name = "interview-public-subnet-b"
    Type = "Public"
  }
}

resource "aws_subnet" "interview_public_subnet_c" {
  cidr_block                = "192.168.128.32/28"
  vpc_id                    = aws_vpc.interview_vpc.id
  availability_zone         = "eu-west-2c"
  map_public_ip_on_launch   = true

  tags = {
    Name = "interview-public-subnet-c"
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

resource "aws_route_table_association" "interview_public_subnet_a" {
  subnet_id       = aws_subnet.interview_public_subnet_a.id
  route_table_id  = aws_route_table.interview_igw_rtb.id
}

resource "aws_route_table_association" "interview_public_subnet_b" {
  subnet_id       = aws_subnet.interview_public_subnet_b.id
  route_table_id  = aws_route_table.interview_igw_rtb.id
}

resource "aws_route_table_association" "interview_public_subnet_c" {
  subnet_id       = aws_subnet.interview_public_subnet_c.id
  route_table_id  = aws_route_table.interview_igw_rtb.id
}
