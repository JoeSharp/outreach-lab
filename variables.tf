variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "eu-west-2" # London
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.large"
}

variable "public_key_path" {
  description = "Path to your public SSH key"
  type        = string
}

variable "my_ip_cidr" {
  description = "Your IP in CIDR format (e.g. 1.2.3.4/32) to allow SSH"
  type        = string
}

variable "key_name" {
  description = "Name of your AWS EC2 key pair"
  type        = string
}
