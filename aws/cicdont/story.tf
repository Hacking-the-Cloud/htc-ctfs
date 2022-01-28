variable "player_username" {
  type        = string
  description = "What is your name? (only used for story purposes)"
}

output "story_description" {
  value = "Hi"
}

output "gitlab_root_password" {
  value = resource.random_string.gitlab_root_password.result
}

output "target_ip" {
  value = aws_instance.target_service.public_ip
}

resource "random_string" "gitlab_root_password" {
  length  = 24
  special = false
}

output "attackbox_ip" {
  value = aws_instance.attackbox.public_ip
}
