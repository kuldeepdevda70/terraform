output "public_ip" {
  value = aws_instance.react_server.public_ip
}

output "instance_id" {
  value = aws_instance.react_server.id
}
