variable "user_name" {
  description = "User's name that is added as a suffix to user-specific resources"
  type        = string
  default     = "test-user"

  validation {
    condition     = length(var.user_name) > 0 && length(var.user_name) < 59
    error_message = "The user's name must be greater than 0 and less than 59 characters"
  }
}

variable "ip" {
  description = "IP of user for bastion security group"
  type        = string
  default     = "0.0.0.0/0"
}