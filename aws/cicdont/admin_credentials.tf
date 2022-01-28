resource "aws_iam_user" "terraform_admin_user" {
  name = "terraform_admin_user"
}

resource "aws_iam_user_policy" "terraform_admin_policy" {
  name = "terraform_admin_policy"
  user = aws_iam_user.terraform_admin_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "terraform_admin_user_access_key" {
  user = aws_iam_user.terraform_admin_user.name
}