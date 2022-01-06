resource "aws_vpc" "ctf_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "ctf_vpc"
  }
}

resource "aws_subnet" "ctf_subnet" {
  vpc_id            = aws_vpc.ctf_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "ctf_subnet"
  }
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "allow_everything" {
  name        = "allow_everything"
  description = "Allow everything tcp inbound"
  vpc_id      = aws_vpc.ctf_vpc.id

  ingress {
    description = "Allow everything"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_everything"
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
  vpc_id = aws_vpc.ctf_vpc.id
  route_table_id = aws_route_table.ctf_route_table.id
}

/* This is the host the player can attack/recieve shells from */
resource "aws_instance" "attackbox" {
  ami                         = data.aws_ami.ubuntu_ami.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.ctf_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_everything.id]
  depends_on = [aws_internet_gateway.ctf_gw]

  user_data = file("attackbox_user_data.sh")

  tags = {
    Name = "attackbox"
  }
}