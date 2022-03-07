resource "aws_iam_user" "aws_admin_user" {
  name = "aws_admin_automation_user"
}

resource "aws_iam_access_key" "aws_admin_user_access_key" {
  user = aws_iam_user.aws_admin_user.name
}