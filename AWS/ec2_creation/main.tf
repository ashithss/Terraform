# Create an AWS key pair resource
resource "aws_key_pair" "example_keypair" {
  key_name   = var.keypair_name  # Set the key pair name using a variable
  public_key = file("~/.ssh/test.pub")  # Update with the path to your public key file
}

# Create an AWS security group resource
resource "aws_security_group" "instance_sg" {
  name        = "InstanceSecurityGroup"  # Set the security group name
  description = "Security group for the EC2 instance"  # Set the security group description

  # Define an ingress rule to allow SSH traffic
  ingress {
    from_port   = 22  # Allow traffic from port 22
    to_port     = 22  # Allow traffic to port 22
    protocol    = "tcp"  # Allow TCP protocol
    cidr_blocks = [var.security_group_ingress_cidr]  # Set the CIDR block for inbound traffic
  }
}

# Create an AWS EC2 instance resource
resource "aws_instance" "example" {
  ami             = var.instance_ami  # Set the Amazon Machine Image (AMI) using a variable
  instance_type   = var.instance_type  # Set the instance type using a variable
  key_name        = aws_key_pair.example_keypair.key_name  # Use the key pair name from the above resource

  security_groups = [aws_security_group.instance_sg.name]  # Associate the security group with the instance

  # Define user data to be executed on instance launch
  user_data = <<-EOF
    #!/bin/bash
    echo "Hello from user data!" > /tmp/user_data_hello.txt
  EOF

  tags = {
    Name = "ExampleInstance"  # Set the name tag for the instance
  }
}

# Create an AWS EBS volume resource
resource "aws_ebs_volume" "example_volume" {
  availability_zone = aws_instance.example.availability_zone  # Use the availability zone of the above instance
  size              = var.volume_size  # Set the volume size using a variable
}

# Attach the EBS volume to the EC2 instance
resource "aws_volume_attachment" "example_attach" {
  device_name  = "/dev/sdh"  # Set the device name for the attached volume
  volume_id    = aws_ebs_volume.example_volume.id  # Use the ID of the above EBS volume
  instance_id  = aws_instance.example.id  # Use the ID of the above EC2 instance
}
