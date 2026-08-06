output "my_ip_add" {
  description = "IP Address of my machine"
  value       = module.my_ip_cidr.value
}

output "lab_dcv_urls" {
  description = "DCV URLs of Lab Machines"
  value = [for s in module.student_lab : s.dcv_url]
}

output "lab_public_ips" {
  description = "Public IP addresses of Lab Machines"
  value = [for s in module.student_lab : s.instance_public_ip]
}

