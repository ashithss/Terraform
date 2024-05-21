output "instance_id" {
  description = "The ID of the created EC2 instance."
  value       = aws_instance.example_instance.id
}

output "load_balancer_dns" {
  description = "The DNS name of the created Load Balancer."
  value       = aws_lb.example_lb.dns_name
}