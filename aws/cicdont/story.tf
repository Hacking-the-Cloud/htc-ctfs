variable "player_username" {
  type        = string
  description = "What is your name? (only used for story purposes. Upper and lowercase letters ONLY)"

  validation {
    condition     = can(regex("^[A-Za-z]+$", var.player_username))
    error_message = "Only lower and uppercase letters are allowed in the username."
  }
}

resource "random_string" "player_password" {
  length  = 24
  special = false
}

output "player_username" {
  value = var.player_username
}

output "player_password" {
  value = resource.random_string.player_password.result
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

output "time_warning" {
  value = "Please be aware the CTF will be ready 10 minutes from the time this message is first displayed"
}