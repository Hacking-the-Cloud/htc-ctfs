resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow 80/tcp inbound"
  vpc_id      = aws_vpc.ctf_vpc.id

  ingress {
    description = "Allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

/* This is the target of the ctf */
resource "aws_instance" "target_service" {
  ami                         = data.aws_ami.ubuntu_ami.id
  instance_type               = "t3.large"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.ctf_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_http.id]
  depends_on = [aws_internet_gateway.ctf_gw]

  user_data = file("target_service_user_data.sh")

  tags = {
    Name = "target_service"
  }
}