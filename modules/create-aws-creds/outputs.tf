output "key_name" {
    value = aws_key_pair.key_pair.key_name
}

output "security_group_id" {
    value = aws_security_group.security_group.id
}