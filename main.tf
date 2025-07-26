provider "aws" {
  region = var.aws_region
}

module "dcv_lab" {
	source = "./dcv_machine"
	count = 2
	lab_name = "sports_day"
	username = "student"
	password = "mypassword"
	my_ip_cidr = var.my_ip_cidr
	instance_type = var.instance_type
	instance_id = count.index
	key_name = aws_key_pair.student_key.key_name
	providers = {
		aws = aws
	}
}
