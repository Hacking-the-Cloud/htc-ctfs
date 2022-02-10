resource "aws_vpc" "ctf_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "ctf_vpc"
  }
}

resource "aws_subnet" "ctf_subnet" {
  vpc_id            = aws_vpc.ctf_vpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.0.0/24"

  tags = {
    Name = "ctf_subnet"
  }
}

resource "aws_internet_gateway" "ctf_gw" {
  vpc_id = aws_vpc.ctf_vpc.id

  tags = {
    Name = "ctf_gw"
  }
}

resource "aws_route_table" "ctf_route_table" {
  vpc_id = aws_vpc.ctf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ctf_gw.id
  }

  tags = {
    Name = "ctf_route_table"
  }
}

resource "aws_main_route_table_association" "ctf_main_rt_assoc" {
  vpc_id         = aws_vpc.ctf_vpc.id
  route_table_id = aws_route_table.ctf_route_table.id
}