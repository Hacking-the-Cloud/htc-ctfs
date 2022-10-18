/* Creates the gamemaster s3 bucket. This contains
   all assets related to the "lore" of the CTF.
     * gamemaster.sh script
     * profile pictures   
*/

resource "aws_s3_bucket" "gamemaster_bucket" {
  bucket_prefix = "gamemaster-htc-"
  acl           = "private"
}

resource "aws_s3_bucket_object" "profile_pictures" {
  for_each = fileset("gamemaster/profile_pictures/", "*")
  bucket   = aws_s3_bucket.gamemaster_bucket.id
  key      = "profile_pictures/${each.value}"
  source   = "gamemaster/profile_pictures/${each.value}"
}

resource "aws_s3_bucket_object" "infra_deployer" {
  for_each = fileset("gamemaster/infra-deployer/", "*")
  bucket   = aws_s3_bucket.gamemaster_bucket.id
  key      = "infra-deployer/${each.value}"
  source   = "gamemaster/infra-deployer/${each.value}"
}

resource "aws_s3_bucket_object" "upload_gamemaster_script" {
  bucket  = aws_s3_bucket.gamemaster_bucket.id
  key     = "gamemaster.sh"
  content = templatefile("./gamemaster/gamemaster.sh", {
    gitlab_root_password = resource.random_string.gitlab_root_password.result
    player_username      = var.player_username
    player_password      = resource.random_string.player_password.result
    access_key           = aws_iam_access_key.aws_admin_user_access_key.id
    secret_key           = urlencode(aws_iam_access_key.aws_admin_user_access_key.secret)
  })
}