
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = templatefile("${path.module}/ansible/inventory.ini", {
    student_lab = module.student_lab
  })
}

resource "local_file" "ansible_group_vars_lab" {
  filename = "${path.module}/../ansible/group_vars/lab.yml"

  content = templatefile("${path.module}/ansible/group_vars/lab.yml", {
    ssh_private_key_path = var.ssh_private_key_path
  })
}
