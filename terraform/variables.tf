variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "eu-west-2" # London
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ssh_public_key_path" {
  description = "Path to your public SSH key"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to your private SSH key"
  type        = string
}

variable "key_name" {
  description = "Name of your AWS EC2 key pair"
  type        = string
}
