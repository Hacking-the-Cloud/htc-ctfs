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
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
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
  length  = 24
  special = false
}

data "template_file" "target_user_data" {
  template = file("target_service_user_data.sh")
  vars = {
    gitlab_root_password = resource.random_string.gitlab_root_password.result
    player_username      = var.player_username
    gamemaster_bucket    = aws_s3_bucket.gamemaster_bucket.id
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
  iam_instance_profile        = aws_iam_instance_profile.cicd_service_profile.name
  depends_on                  = [aws_internet_gateway.ctf_gw]

  user_data = data.template_file.target_user_data.rendered

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "target_service"
  }
}

resource "aws_iam_role" "cicd_service_role" {
  name                = "cicd_service_role"
  managed_policy_arns = [aws_iam_policy.read_gamemaster_bucket.arn]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_cicd_service_role" {
  role       = aws_iam_role.cicd_service_role.name
  policy_arn = aws_iam_policy.read_gamemaster_bucket.arn
}

resource "aws_iam_instance_profile" "cicd_service_profile" {
  name = "cicd_service_instance_profile"
  role = aws_iam_role.cicd_service_role.name
}

resource "aws_iam_policy" "read_gamemaster_bucket" {
  name = "read_gamemaster_bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.gamemaster_bucket.arn,
          "${aws_s3_bucket.gamemaster_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket" "gamemaster_bucket" {
  bucket_prefix = "gamemaster-htc-"
  acl           = "private"
}

resource "aws_s3_bucket_object" "objects" {
  for_each = fileset("./gamemaster", "*")
  bucket   = aws_s3_bucket.gamemaster_bucket.id
  key      = each.value
  source   = "./gamemaster/${each.value}"
}