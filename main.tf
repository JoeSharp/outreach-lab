provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "student_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "dcv_sg" {
  name        = "student-dcv-sg"
  description = "Allow SSH and NICE DCV access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
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

resource "aws_instance" "student_vm" {
  ami                    = var.ubuntu_ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.student_key.key_name
  vpc_security_group_ids = [aws_security_group.dcv_sg.id]

  user_data              = file("${path.module}/user_data.sh")

  tags = {
    Name = "student-desktop"
  }
}
