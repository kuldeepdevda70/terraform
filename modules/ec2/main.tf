# SECURITY GROUP
resource "aws_security_group" "react_sg" {
  name        = var.sg_name
  description = "Allow HTTP, HTTPS, SSH"
  vpc_id      = var.vpc_id

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

  tags = {
    Name = var.sg_name
  }
}

# LAUNCH TEMPLATE
resource "aws_launch_template" "react_lt" {
  name_prefix   = "react-lt-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.react_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              set -e

              apt update -y
              apt install -y git software-properties-common

              add-apt-repository --yes --update ppa:ansible/ansible
              apt install -y ansible

              git clone ${var.ansible_repo} /home/ubuntu/app
              cd /home/ubuntu/app
              git checkout ${var.repo_version}
              ansible-playbook -i localhost, -c local playbook.yml
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "react-asg-instance"
    }
  }
}

# AUTOSCALING GROUP
resource "aws_autoscaling_group" "react_asg" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = var.public_subnets

  launch_template {
    id      = aws_launch_template.react_lt.id
    version = "$Latest"
  }

  target_group_arns = var.target_group_arns

  tag {
    key                 = "Name"
    value               = "react-asg"
    propagate_at_launch = true
  }
}