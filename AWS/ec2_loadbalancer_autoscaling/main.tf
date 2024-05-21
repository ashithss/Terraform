resource "aws_instance" "example_instance" {
  count         = var.desired_capacity  # Create multiple instances based on the desired capacity
  ami           = var.instance_ami  # Set the Amazon Machine Image (AMI) using a variable
  instance_type = var.instance_type  # Set the instance type using a variable
  subnet_id     = element(var.subnets, count.index)  # Assign a subnet from the list based on the instance count

  tags = {
    Name = "ExampleInstance-${count.index}"  # Set a dynamic name tag for each instance
  }
}

resource "aws_security_group" "instance_sg" {
  name_prefix = "instance_sg"  # Set a prefix for the security group name

  # Add your security group rules here
  ingress {
    from_port   = 22  # Allow traffic from port 22
    to_port     = 22  # Allow traffic to port 22
    protocol    = "tcp"  # Allow TCP protocol
    cidr_blocks = ["0.0.0.0/0"]  # Allow inbound traffic from any IP address
  }
}

resource "aws_lb" "example_lb" {
  name               = "example-lb"  # Set the name of the load balancer
  internal           = false  # Set whether the load balancer is internal or external
  load_balancer_type = "application"  # Set the load balancer type to application
  enable_deletion_protection = false  # Disable deletion protection for the load balancer

  enable_http2    = true  # Enable HTTP/2 for the load balancer
  enable_cross_zone_load_balancing = true  # Enable cross-zone load balancing for the load balancer

  security_groups = [aws_security_group.instance_sg.id]  # Associate the security group with the load balancer
  subnets         = var.subnets  # Set the subnets where the load balancer will be deployed
}

resource "aws_lb_target_group" "example_target_group" {
  name     = "example-target-group0987"  # Set the name of the target group
  port     = 80  # Set the port for the target group
  protocol = "HTTP"  # Set the protocol for the target group
  vpc_id   = var.vpc_id  # Set the ID of the VPC where the target group will be created

  health_check {
    healthy_threshold   = 2  # Set the number of consecutive successful health checks required for a target to be considered healthy
    unhealthy_threshold = 2  # Set the number of consecutive failed health checks required for a target to be considered unhealthy
    timeout             = 3  # Set the amount of time, in seconds, during which no response means a failed health check
    interval            = 30  # Set the interval between health checks, in seconds
    path                = "/"  # Set the health check path
  }
}

resource "aws_autoscaling_group" "example_autoscaling" {
  name                 = "example-asg"  # Set the name of the autoscaling group
  max_size             = var.max_instances  # Set the maximum number of instances in the autoscaling group
  min_size             = var.min_instances  # Set the minimum number of instances in the autoscaling group
  desired_capacity     = var.desired_capacity  # Set the desired capacity of the autoscaling group
  launch_configuration = aws_launch_configuration.example_launch_config.name  # Set the launch configuration for the autoscaling group
  vpc_zone_identifier  = var.subnets  # Set the subnets where the instances will be launched

  health_check_type        = "ELB"  # Set the health check type to ELB
  health_check_grace_period = 300  # Set the health check grace period, in seconds
}

resource "aws_launch_configuration" "example_launch_config" {
  name_prefix                  = "example-lc"  # Set a prefix for the launch configuration name
  image_id                     = var.instance_ami  # Set the Amazon Machine Image (AMI) using a variable
  instance_type                = var.instance_type  # Set the instance type using a variable
  security_groups              = [aws_security_group.instance_sg.id]  # Associate the security group with the launch configuration
  associate_public_ip_address  = true  # Associate a public IP address with the instances

  lifecycle {
    create_before_destroy = true  # Create a new launch configuration before destroying the old one
  }
}

resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.example_lb.arn  # Set the ARN of the load balancer
  port              = 80  # Set the port for the listener
 protocol          = "HTTP"  # Set the protocol for the listener

  default_action {
    target_group_arn = aws_lb_target_group.example_target_group.arn  # Set the ARN of the target group to forward traffic to
    type             = "forward"  # Set the action type to forward
  }
}
