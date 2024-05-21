resource "aws_ecs_cluster" "web-cluster" {
  name               = var.cluster_name  # Name of the ECS cluster
  #capacity_providers = aws_ecs_capacity_provider.test.name
  tags = {
    "env"       = "dev"  # Tag for environment (dev)
    "createdBy" = "binpipe"  # Tag for creator (binpipe)
  }
}

#resource "aws_iam_service_linked_role" "ecs" {
#  aws_service_name = "ecs.amazonaws.com"
#}

resource "aws_ecs_capacity_provider" "test" {
  name = "capacity-provider-test"  # Name of the ECS capacity provider
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn  # ARN of the Auto Scaling Group associated with the capacity provider
    managed_termination_protection = "ENABLED"  # Enables termination protection for managed instances

    managed_scaling {
      status          = "ENABLED"  # Enables managed scaling for the capacity provider
      target_capacity = 85  # Sets the target capacity to 85%
    }
  }
}

#resource "aws_ecs_task_definition" "task-definition-test" {
  family                = "web-family"  # Family name for the task definition
  container_definitions = file("container-definitions/container-def.json")  # Path to the container definition JSON file
  network_mode          = "bridge"  # Network mode for the task

  tags = {
    "env"       = "dev"  # Tag for environment (dev)
    "createdBy" = "binpipe"  # Tag for creator (binpipe)
  }
}

resource "aws_ecs_service" "service" {
  name            = "web-service"  # Name of the ECS service
  cluster         = aws_ecs_cluster.web-cluster.id  # ID of the ECS cluster
  task_definition = aws_ecs_task_definition.task-definition-test.arn  # ARN of the ECS task definition
  desired_count   = 10  # Desired number of tasks to run

  ordered_placement_strategy {
    type  = "binpack"  # Placement strategy type
    field = "cpu"  # Field to use for placement strategy
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn  # ARN of the target group
    container_name   = "binpipe-devops"  # Name of the container
    container_port   = 80  # Port on which the container listens
  }

  lifecycle {
    ignore_changes = [desired_count]  # Ignores changes to the desired_count attribute during Terraform plan
  }

  launch_type = "EC2"  # Launch type for the service
  depends_on  = [aws_lb_listener.web-listener]  # Specifies dependencies for the service
}
resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/frontend-container"  # Name of the CloudWatch log group
  tags = {
    "env"       = "dev"  # Tag for environment (dev)
    "createdBy" = "binpipe"  # Tag for creator (binpipe)
  }
}
