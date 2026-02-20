module "ec2_server" {
  source        = "../../modules/EC2"
  
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  instance_name = "react-server"
  sg_name       = "react-sg"
  ansible_repo  = var.ansible_repo  
}

# Outputs
output "ec2_public_ip" {
  value = module.ec2_server.public_ip
}

output "ec2_instance_id" {
  value = module.ec2_server.instance_id
}
