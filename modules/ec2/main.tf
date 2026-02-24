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

resource "aws_launch_template" "blue_lt" {
  name_prefix   = "react-blue-"
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
              git checkout ${var.blue_version}
              ansible-playbook -i localhost, -c local playbook.yml
              EOF
  )
}

resource "aws_launch_template" "green_lt" {
  name_prefix   = "react-green-"
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
              git checkout ${var.green_version}
              ansible-playbook -i localhost, -c local playbook.yml
              EOF
  )
}

resource "aws_autoscaling_group" "blue_asg" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = var.public_subnets

  launch_template {
    id      = aws_launch_template.blue_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.blue_target_group_arn]

  tag {
    key                 = "Name"
    value               = "react-blue-asg"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_group" "green_asg" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = var.public_subnets

  launch_template {
    id      = aws_launch_template.green_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.green_target_group_arn]

  tag {
    key                 = "Name"
    value               = "react-green-asg"
    propagate_at_launch = true
  }
}


