variable "subnet_id" {
  description = "Subnet on which to add bastion server"
  type        = string
  default     = "subnet-0049f4d61f261d51d"
  validation {
    condition     = length(var.subnet_id) > 7 && substr(var.subnet_id, 0, 7) == "subnet-"
    error_message = "The subnet_id value must be a valid Subnet id, starting with \"subnet-\"."
  }
}

variable "image_id" {
  description = "Base image of EC2 instance aka Bastion"
  type        = string
  default     = "ami-026b57f3c383c2eec"

  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "instance_type" {
  description = "Type of EC2 instance aka Bastion server"
  type        = string
  default     = "t2.micro"
}

variable "user_name" {
  description = "User's name that is added as a suffix to user-specific resources"
  type        = string
  default     = "test-user"

  validation {
    condition     = length(var.user_name) > 0 && length(var.user_name) < 59
    error_message = "The user's name must be greater than 0 and less than 59 characters"
  }
}

variable "key_name" {
  description = "Key name associated with user's key-pair"
  type        = string
  default     = "test-key-pair"
}

variable "security_group_id" {
  description = "ID of security group associated with the user"
  type        = string
  default     = "test-security-group"
}
