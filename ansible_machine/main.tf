resource "aws_instance" "student_vm" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  user_data              = templatefile("${path.module}/user_data.tpl.sh")

  tags = {
    Name = "student-desktop"
  }
}
