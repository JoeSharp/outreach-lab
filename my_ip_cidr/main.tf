data "external" "my_ip_addr" {
	program = ["bash", "-c", "curl -s 'https://ipinfo.io/json'"]
}

output "value" {
  description = "Play output value"
  value       = format("%s/32", data.external.my_ip_addr.result.ip)
}
