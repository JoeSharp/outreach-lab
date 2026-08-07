provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "dcv_sg" {
  name        = "student-dcv-sg"
  description = "Allow SSH and NICE DCV access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NICE DCV Web Access"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "student_lab" {
	source = "./student_machine"
	count = 1
	security_group_id = aws_security_group.dcv_sg.id
	instance_type = var.instance_type
	instance_id = count.index
	key_name = aws_key_pair.student_key.key_name
	providers = {
		aws = aws
	}
}
