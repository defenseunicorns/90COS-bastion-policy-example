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

variable "main_vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/24"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "test-project"
}

variable "public_subnets" {
  description = "Public Subnet IPs"
  type        = string
  default     = "10.0.0.128/26"
}

variable "users" {
  description = "value"
  type = list(string)
  default = []
}