# Create AWS credentials
# - Create key-pair
# - Create Security Group for user + machine IP address (should I do the IP?)

# Create key-pair for user
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "key-${var.user_name}"
  public_key = tls_private_key.key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo "${tls_private_key.key.private_key_pem}" > ${var.user_name}-key.pem
    EOT
  }
}

# Create Security Group
resource "aws_security_group" "security_group" {
  name = "security-group-${var.user_name}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ip}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}