output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.student_vm.public_ip
}

output "instance_id" {
  description = "The instance ID of the EC2"
  value       = aws_instance.student_vm.id
}

output "dcv_url" {
  description = "NICE DCV connection URL"
  value       = "https://${aws_instance.student_vm.public_dns}:8443"
}

