output "load_balancer_dns" {
  description = "The DNS name of the created Load Balancer."
  value       = aws_lb.example_lb.dns_name
}

output "autoscaling_group_name" {
  description = "The name of the created Auto Scaling group."
  value       = aws_autoscaling_group.example_autoscaling.name
}