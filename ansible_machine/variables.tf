variable "instance_id" {
  description = "The ID of the instance within the lab"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.large"
}

variable "key_name" {
  description = "Name of your AWS EC2 key pair"
  type        = string
}

variable "ansible_playbook" {
  description = "ARN of the Ansible Playbook"
  type        = string
}

variable "username" {
  description = "Username for the DCV session"
  type = string
}

variable "password" {
  description = "Password for the DCV session"
  type = string
}
