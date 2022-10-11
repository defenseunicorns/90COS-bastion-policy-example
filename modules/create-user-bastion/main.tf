# Create user's bastion server + associated policy/roles
# - Create Role - policy is for EC2 resource to use the role
# - Create IAM instance profile for role
# - Create EC2 instance (bastion server); attach role, security group

# Create Role
resource "aws_iam_role" "role" {
  name = "role-${var.user_name}"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "sts:AssumeRole"
        ],
        Principal : {
          Service : [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion-profile-${var.user_name}"
  role = aws_iam_role.role.name
}

# Create Bastion Server
resource "aws_instance" "bastion_server" {
  ami                  = var.image_id
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  iam_instance_profile = aws_iam_instance_profile.bastion_profile.name
  key_name             = var.key_name
  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = {
    Name = "bastion-${var.user_name}"
  }
}

# Get EIP
resource "aws_eip" "elasticip" {
  instance = aws_instance.bastion_server.id
}
