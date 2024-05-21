resource "aws_lb" "test-lb" {
  name               = "test-ecs-lb"  # Name of the load balancer
  load_balancer_type = "application"  # Type of the load balancer
  internal           = false  # Specifies whether the load balancer is internal or external
  subnets            = module.vpc.public_subnets  # Subnets in which the load balancer should be placed
  tags = {
    "env"       = "dev"  # Environment tag for the load balancer
    "createdBy" = "binpipe"  # CreatedBy tag for the load balancer
  }
  security_groups = [aws_security_group.lb.id]  # Security groups associated with the load balancer
}

resource "aws_security_group" "lb" {
  name   = "allow-all-lb"  # Name of the security group
  vpc_id = data.aws_vpc.main.id  # ID of the VPC to which the security group belongs

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
    "env"       = "dev"  # Environment tag for the security group
    "createdBy" = "binpipe"  # CreatedBy tag for the security group
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name        = "binpipe-target-group"  # Name of the target group
  port        = "80"  # Port on which the targets receive traffic
  protocol    = "HTTP"  # Protocol used for the target group
  target_type = "instance"  # Type of targets in the target group
  vpc_id      = data.aws_vpc.main.id  # ID of the VPC in which the target group is created

  health_check {
    path                = "/"  # Path used for health checks
    healthy_threshold   = 2  # Number of consecutive successful health checks to consider a target healthy
    unhealthy_threshold = 10  # Number of consecutive failed health checks to consider a target unhealthy
    timeout             = 60  # Timeout value for health checks
    interval            = 300  # Interval between health checks
    matcher             = "200,301,302"  # HTTP response codes indicating a healthy target
  }
}

resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.test-lb.arn  # ARN of the load balancer
  port              = "80"  # Listener port
  protocol          = "HTTP"  # Listener protocol

  default_action {
    type             = "forward"  # Default action type
    target_group_arn = aws_lb_target_group.lb_target_group.arn  # ARN of the target group to forward traffic to
  }
}
