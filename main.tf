# Orchestrate creation of users, projects, and linkages between the two

# Add provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

# (store state in S3 bucket?)

# Create user credentials in AWS
module "create_aws_creds" {
  for_each = { for user in var.users : user.user_name => user }
  source   = "./modules/create-aws-creds"

  user_name = each.value.user_name
  ip        = each.value.machine_ip
}

# Create user's bastion server
module "create_bastion_server" {
  for_each = { for user in var.users : user.user_name => user }
  source   = "./modules/create-user-bastion"

  user_name         = each.value.user_name
  key_name          = module.create_aws_creds[each.key].key_name
  security_group_id = module.create_aws_creds[each.key].security_group_id
}

# Create VPC for projects
module "create_projects_vpc" {
  for_each = { for project in var.project_users : project.project_name => project }
  source   = "./modules/create-project-vpc"

  project_name = each.value.project_name
  users        = each.value.users
  account_id   = var.account_id
  aws_region   = var.aws_region
}
