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

resource "random_string" "gitlab_root_password" {
  length = 24
  special = false
}

data "template_file" "target_user_data" {
  template = file("target_service_user_data.sh")
  vars = {
    gitlab_root_password = resource.random_string.gitlab_root_password.result
  }
}

output "gitlab_root_password" {
  value = resource.random_string.gitlab_root_password.result
}

output "target_ip" {
  value = aws_instance.target_service.public_ip
}

/* This is the target of the ctf */
resource "aws_instance" "target_service" {
  ami                         = data.aws_ami.ubuntu_ami.id
  instance_type               = "t3.large"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.ctf_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_http.id]
  depends_on = [aws_internet_gateway.ctf_gw]

  user_data = data.template_file.target_user_data.rendered

  tags = {
    Name = "target_service"
  }
}