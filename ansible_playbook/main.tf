locals {
  epoch_suffix = formatdate("YYYYMMDDhhmmss", timestamp())
  playbook = templatefile("${path.module}/playbook.tpl.yml", {
    username = "student"
    password = "SecurePass123"
  })
}

resource "aws_s3_bucket" "playbook_bucket" {
  bucket = "student-lab-playbooks-${local.epoch_suffix}"
  tags = {
    Name = "Student Lab Ansible Playbook bucket"
  }
}

resource "aws_s3_object" "ansible_playbook" {
  bucket = aws_s3_bucket.playbook_bucket.id
  key    = "playbook.yml"
  content = local.playbook
  content_type = "text/yaml"
}

output "playbook" {
  description = "S3 Bucket ID"
  value = {
    bucket = aws_s3_bucket.playbook_bucket.id
    key = aws_s3_object.ansible_playbook.id
  }
}

