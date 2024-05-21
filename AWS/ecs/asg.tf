data "aws_ami" "amazon_linux" {
  most_recent = true # Retrieve the most recent AMI

  filter {
    name   = "name" # Filter by name
    values = ["amzn-ami*amazon-ecs-optimized"] # AMI name pattern to match
  }

  filter {
    name   = "architecture" # Filter by architecture
    values = ["x86_64"] # Architecture value to match
  }

  filter {
    name   = "virtualization-type" # Filter by virtualization type
    values = ["hvm"]  # Virtualization type value to match
  }
  owners = ["amazon", "self"] # Specify the owners of the AMI to search for
}

resource "aws_security_group" "ec2-sg" {
  name        = "allow-all-ec2"  # Name of the security group
  description = "allow all"  # Description of the security group
  vpc_id      = data.aws_vpc.main.id  # ID of the VPC to which the security group belongs

  ingress {
    from_port   = 0  # Ingress rule: from port
    to_port     = 0  # Ingress rule: to port
    protocol    = "-1"  # Ingress rule: protocol (-1 indicates all protocols)
    cidr_blocks = ["0.0.0.0/0"]  # Ingress rule: CIDR blocks allowed
  }

  egress {
    from_port   = 0  # Egress rule: from port
    to_port     = 0  # Egress rule: to port
    protocol    = "-1"  # Egress rule: protocol (-1 indicates all protocols)
    cidr_blocks = ["0.0.0.0/0"]  # Egress rule: CIDR blocks allowed
  }

  tags = {
    Name = "binpipe"  # Name tag for the security group
  }
}

resource "aws_launch_configuration" "lc" {
  name          = "test_ecs"  # Name of the launch configuration
  image_id      = data.aws_ami.amazon_linux.id  # ID of the Amazon Machine Image (AMI) to use
  instance_type = "t2.micro"  # EC2 instance type

  lifecycle {
    create_before_destroy = true  # Create a new launch configuration before destroying the existing one
  }

  iam_instance_profile        = aws_iam_instance_profile.ecs_service_role.name  # IAM instance profile for the EC2 instances
  key_name                    = var.key_name  # Name of the SSH key pair to associate with the instances
  security_groups             = [aws_security_group.ec2-sg.id]  # Security groups associated with the instances
  associate_public_ip_address = true  # Associate a public IP address with the instances
  user_data                   = <<EOF
#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
EOF
}

resource "aws_autoscaling_group" "asg" {
  name                      = "test-asg"  # Name of the Auto Scaling Group (ASG)
  launch_configuration      = aws_launch_configuration.lc.name  # Name of the launch configuration for the ASG
  min_size                  = 3  # Minimum number of instances in the ASG
  max_size                  = 4  # Maximum number of instances in the ASG
  desired_capacity          = 3  # Desired number of instances in the ASG
  health_check_type         = "ELB"  # Health check type for the instances
  health_check_grace_period = 300  # Grace period for health checks
  vpc_zone_identifier       = module.vpc.public_subnets  # Subnets in which the instances should be launched

  target_group_arns     = [aws_lb_target_group.lb_target_group.arn]  # Target groups to associate with the instances
  protect_from_scale_in = true  # Prevent instances from being terminated during scale-in events

  lifecycle {
    create_before_destroy = true  # Create a new ASG before destroying the existing one
  }
}
