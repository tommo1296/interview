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

resource "aws_subnet" "interview_private_subnets" {
  count = length(local.public_subnets)

  cidr_block                = element(local.private_subnets, count.index)
  vpc_id                    = aws_vpc.interview_vpc.id
  availability_zone         = element(local.azs, count.index)

  tags = {
    Name = "interview-private-subnet-${element(local.azs, count.index)}"
    Type = "Private"
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
    Name = "interview-igw-rtb"
  }
}

resource "aws_route_table_association" "interview_public_subnets" {
  count = length(local.public_subnets)

  subnet_id       = element(aws_subnet.interview_public_subnets.*.id, count.index)
  route_table_id  = aws_route_table.interview_igw_rtb.id
}

resource "aws_eip" "interview_nat_gw_eip" {
  tags = {
    Name = "interview-nat-gw-eip"
  }
}

resource "aws_nat_gateway" "interview_nat_gw" {
  allocation_id   = aws_eip.interview_nat_gw_eip.id
  subnet_id       = aws_subnet.interview_public_subnets[0].id

  tags = {
    Name = "interview-nat-gw"
  }
}

resource "aws_route_table" "interview_nat_gw_rtb" {
  vpc_id = aws_vpc.interview_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.interview_nat_gw.id
  }

  tags = {
    Name = "interview-nat-gw-rtb"
  }
}

resource "aws_route_table_association" "interview_private_subnets" {
  count = length(local.private_subnets)

  subnet_id       = element(aws_subnet.interview_private_subnets.*.id, count.index)
  route_table_id  = aws_route_table.interview_nat_gw_rtb.id
}
