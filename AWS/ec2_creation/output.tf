output "instance_public_ip" {
  value = aws_instance.example.public_ip
  description = "Public IP address of the created instance"
}

output "security_group_id" {
  value = aws_security_group.instance_sg.id
  description = "ID of the created security group"
}

output "volume_id" {
  value = aws_ebs_volume.example_volume.id
  description = "ID of the created EBS volume"
}