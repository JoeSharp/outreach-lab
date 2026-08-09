resource "aws_instance" "student_vm" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  iam_instance_profile   = var.instance_profile
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3" 
    encrypted   = true
  }

  tags = {
    Name = var.student_name
  }
}
