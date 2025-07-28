data "template_file" "ansible_playbook" {
  template = file("${path.module}/playbook.tpl.yml")

  vars = {
    username = "student"
    password = "SecurePass123"
  }
}

locals {
  epoch_suffix = formatdate("YYYYMMDDhhmmss", timestamp())
}

resource "aws_s3_bucket" "playbook_bucket" {
  bucket = "dcv-lab-playbooks-${local.epoch_suffix}"
  acl    = "private"
  tags = {
    Name = "DCV Lab Playbook Bucket"
  }
}

resource "aws_s3_object" "ansible_playbook" {
  bucket = aws_s3_bucket.playbook_bucket.id
  key    = "playbook.yml"
  content = data.template_file.ansible_playbook.rendered
  content_type = "text/yaml"
}

