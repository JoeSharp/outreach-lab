provider "aws" {
  region = var.aws_region
}

module "my_ip_cidr" {
	source = "./my_ip_cidr"
}

module "ansible_playbook" {
	source = "./ansible_playbook"
}

resource "aws_security_group" "dcv_sg" {
  name        = "student-dcv-sg"
  description = "Allow SSH and NICE DCV access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.my_ip_cidr.value]
  }

  ingress {
    description = "NICE DCV Web Access"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # or lock to your school IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "student_lab" {
	source = "./ansible_machine"
	count = 1
	security_group_id = aws_security_group.dcv_sg.id
	instance_type = var.instance_type
	instance_id = count.index
	key_name = aws_key_pair.student_key.key_name
	ansible_playbook = module.ansible_playbook.playbook
	providers = {
		aws = aws
	}
}
