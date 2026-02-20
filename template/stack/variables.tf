variable "aws_region" {
  description = "AWS region to deploy"
  type        = string
  default     = "eu-central-1"
}

variable "ami" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-01f79b1e4a5c64257"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "AWS key pair name"
  type        = string
  default     = "test"
}

variable "ansible_repo" {
  description = "Git repository URL for Ansible project"
  type        = string
  default     = "https://github.com/kuldeepdevda70/EC2.git"
}

variable "repo_version" {
  description = "Git tag or branch to checkout"
  type        = string
  default     = "master"
}
