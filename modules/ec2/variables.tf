variable "sg_name" {}
variable "vpc_id" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "ansible_repo" {}
variable "repo_version" {}
variable "public_subnets" {
  type = list(string)
}
variable "target_group_arns" {
  type = list(string)
  default = []
}