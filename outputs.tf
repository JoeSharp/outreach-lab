output "my_ip_add" {
  description = "IP Address of my machine"
  value       = module.my_ip_cidr.value
}

output "ansible_playbook" {
  description = "S3 Bucket for Playbook"
  value       = module.ansible_playbook.playbook
}

output "lab_dcv_urls" {
  description = "DCV URLs of Lab Machines"
  value = [for s in module.student_lab : s.dcv_url]
}

