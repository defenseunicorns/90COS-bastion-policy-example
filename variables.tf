variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "Account ID for resource creation"
  type        = string
  default     = ""
}

variable "users" {
  description = "Set of users and associated IP address to generate credentials and bastion servers"
  type = list(object({
    user_name  = string
    machine_ip = string
  }))

  default = [
    {
      user_name  = "jimhalpert"
      machine_ip = "0.0.0.0/0"
    },
    {
      user_name  = "michaelscott"
      machine_ip = "0.0.0.0/0"
    }
  ]

  validation {
    condition = length([
      for o in var.users : true
      if length(o.user_name) > 0 && length(o.user_name) < 59
    ]) == length(var.users)
    error_message = "The user's name must be greater than 0 and less than 59 characters"
  }
}

variable "project_users" {
  description = "User's assigned to each project"
  type = list(object({
    project_name = string
    users        = list(string)
  }))
  default = [{
    project_name = "sales-project"
    users        = ["jimhalpert", "michaelscott"]
    },
    {
      project_name = "accounting-project"
      users        = ["michaelscott"]
  }]
}