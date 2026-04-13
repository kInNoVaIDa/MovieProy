
output "api1_public_ip" {
  value = aws_instance.api1.public_ip
}

output "api2_public_ip" {
  value = aws_instance.api2.public_ip
}

output "rabbitmq_public_ip" {
  value = aws_eip.rabbitmq_eip.public_ip
}

output "mongodb_public_ip" {
  value = aws_eip.mongodb_eip.public_ip
}

output "worker_public_ip" {
  value = aws_instance.worker.public_ip
}

output "load_balancer_url" {
  value = aws_lb.api_lb.dns_name
}