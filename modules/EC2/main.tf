# Security Group
resource "aws_security_group" "react_sg" {
  name        = var.sg_name
  description = "Allow SSH, HTTP, HTTPS"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = var.sg_name }
}

resource "aws_instance" "react_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.react_sg.id]


user_data = <<-EOF
              #!/bin/bash
              set -e

              sudo apt update -y
              sudo apt install -y git software-properties-common

              sudo add-apt-repository --yes --update ppa:ansible/ansible
              sudo apt install -y ansible

              git clone -b ${var.repo_version} ${var.ansible_repo} /home/ubuntu/app
              cd /home/ubuntu/app
              ansible-playbook -i localhost, -c local playbook.yml
              EOF

  tags = { Name = var.instance_name }
  
}
