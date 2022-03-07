variable "consent" {
  type        = string
  description = "By playing this CTF you understand that you are responsible for the costs associated with deploying this infrastructure using Terraform. While attempts have been made to ensure that costs are as low as possible, this CTF was created by memebers of Hacking the Cloud's community and no guarantees can be made. Please do not modify this configuration and please ensure you use `terraform destroy` to clean it up. Please do not deploy this in an account with irrecoverable data. Do you consent? (yes/no)"

  validation {
    condition     = lower(var.consent) == "yes"
    error_message = "Consent message was not approved. Canceling deployment."
  }
}