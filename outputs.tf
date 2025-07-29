output "my_ip_add" {
  description = "IP Address of my machine"
  value       = module.my_ip_cidr.value
}

output "ansible_playbook" {
  description = "S3 Bucket for Playbook"
  value       = module.ansible_playbook.playbook
}

