

module "ec2" {
  source            = "../../modules/ec2"
  sg_name           = "react-sg"
  vpc_id            = var.vpc_id
  ami               = var.ami
  instance_type     = var.instance_type
  key_name          = var.key_name
  ansible_repo      = var.ansible_repo
  repo_version      = var.repo_version
  public_subnets    = var.public_subnets
  target_group_arns = [module.alb.target_group_arn]  # ✅ Pass TG ARN from LB
}

module "alb" {
  source         = "../../modules/load-balancer"
  vpc_id         = var.vpc_id
  public_subnets = var.public_subnets
  sg_id          = module.ec2.sg_id  # SG ID from EC2 module
}

output "alb_dns" {
  value = module.alb.alb_dns
}