variable "instance_id" {
  description = "The ID of the instance within the lab"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.large"
}

variable "lab_name" {
  description = "The name for the lab"
  type        = string
  default     = "outreach"
}

variable "username" {
  description = "The username for the DCV session"
  type        = string
}

variable "password" {
  description = "The password for the DCV session"
  type        = string
}

variable "key_name" {
  description = "Name of your AWS EC2 key pair"
  type        = string
}

variable "my_ip_cidr" {
  description = "Your IP in CIDR format (e.g. 1.2.3.4/32) to allow SSH"
  type        = string
}
