resource "aws_iam_user" "terraform_admin_user" {
  name = "terraform_admin_user"
}

resource "aws_iam_access_key" "terraform_admin_user_access_key" {
  user = aws_iam_user.terraform_admin_user.name
}