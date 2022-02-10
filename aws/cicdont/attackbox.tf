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

data "template_file" "attackbox_user_data" {
  template = file("attackbox_user_data.sh")
  vars = {
    player_password = random_string.player_password.result
    player_username = var.player_username
  }
}

/* This is the host the player can attack/recieve shells from */
resource "aws_instance" "attackbox" {
  ami                         = data.aws_ami.ubuntu_ami.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.ctf_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_everything.id]
  depends_on                  = [aws_internet_gateway.ctf_gw]

  user_data = data.template_file.attackbox_user_data.rendered

  tags = {
    Name = "attackbox"
  }
}