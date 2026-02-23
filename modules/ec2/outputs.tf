output "sg_id" {
  value = aws_security_group.react_sg.id
}

output "launch_template_id" {
  value = aws_launch_template.react_lt.id
}

output "asg_id" {
  value = aws_autoscaling_group.react_asg.id
}