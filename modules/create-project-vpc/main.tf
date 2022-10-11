# Create a VPC for a specified Project
# - Create VPC + associated components
# - Create Policy to read/write items to VPC
# - Attach users to project via policy attachment

# Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.main_vpc_cidr # Defining the CIDR block use 10.0.0.0/24 for demo
  instance_tenancy = "default"

  tags = {
    Name = "vpc-${var.project_name}"
  }
}

# Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# Create a Public Subnets.
resource "aws_subnet" "public_subnets" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnets
}

# Route table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Route table Association with Public Subnets
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnets.id
  route_table_id = aws_route_table.public_rt.id
}

# 2) Create Policy to read/write items to VPC
resource "aws_iam_policy" "project_policy" {
  name = "policy-${var.project_name}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "stmt1",
        "Effect" : "Allow",
        "Action" : "ec2:RunInstances",
        "Resource" : "arn:aws:ec2:${var.aws_region}:${var.account_id}:subnet/*",
        "Condition" : {
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.aws_region}:${var.account_id}:vpc/${aws_vpc.vpc.id}"
          }
        }
      },
      {
        "Sid" : "stmt2",
        "Effect" : "Allow",
        "Action" : "ec2:RunInstances",
        "Resource" : "arn:aws:ec2:${var.aws_region}::image/ami-*"
      },
      {
        "Sid" : "stmt3",
        "Effect" : "Allow",
        "Action" : "ec2:RunInstances",
        "Resource" : [
          "arn:aws:ec2:${var.aws_region}:${var.account_id}:security-group/*",
          "arn:aws:ec2:${var.aws_region}:${var.account_id}:network-interface/*",
          "arn:aws:ec2:${var.aws_region}:${var.account_id}:instance/*",
          "arn:aws:ec2:${var.aws_region}:${var.account_id}:key-pair/*",
          "arn:aws:ec2:${var.aws_region}:${var.account_id}:volume/*"
        ]
      }
    ]
  })
}

# Associate users to project
resource "aws_iam_policy_attachment" "bastion_policy_role" {
  name       = "policy-attachment-${var.project_name}"
  roles      = [ for i in var.users : "role-${i}" ]
  policy_arn = aws_iam_policy.project_policy.arn
}