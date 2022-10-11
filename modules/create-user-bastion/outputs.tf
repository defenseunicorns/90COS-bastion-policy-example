output "eip" {
  value = aws_eip.elasticip.public_ip
}

output "bastion_role_name" {
  value = aws_iam_role.role.name
}