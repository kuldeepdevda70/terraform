variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "instance_name" {}
variable "sg_name" {}
variable "ansible_repo" {}
variable "repo_version" {
  description = "Git tag or branch to checkout"
  type        = string
}
