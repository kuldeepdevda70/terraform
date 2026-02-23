# variables.tf
variable "vpc_id" {}
variable "public_subnets" { type = list(string) }
variable "sg_id" {}