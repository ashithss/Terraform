resource "aws_iam_role" "ecs-instance-role" {
  name = "ecs-instance-role-test-web"  # Name of the IAM role
  path = "/"  # Path for the IAM role

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = aws_iam_role.ecs-instance-role.name  # Name of the IAM role to attach the policy to
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"  # ARN of the IAM policy to attach
}

resource "aws_iam_instance_profile" "ecs_service_role" {
  role = aws_iam_role.ecs-instance-role.name  # Name of the IAM role for the instance profile
}
