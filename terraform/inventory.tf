
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = join("\n", concat(
    ["[lab]"],
    [
      for idx, s in module.student_lab :
      "student${idx + 1} ansible_host=${s.instance_public_ip}"
    ]
  ))
}

resource "local_file" "ansible_group_vars_lab" {
  filename = "${path.module}/../ansible/group_vars/lab.yml"

  content = <<EOF
ansible_user: ubuntu
student_user: ubuntu
student_password: student123
ansible_ssh_private_key_file: ${var.ssh_private_key_path}
EOF
}
