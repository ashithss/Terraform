# Configure the AWS provider with the specified region
provider "aws" {
  region = var.region
}

# Create an AWS IAM user named "John"
resource "aws_iam_user" "John" {
  name = var.user_name
}

# Create an AWS IAM group named "Demo-group"
resource "aws_iam_group" "Demo-group" {
  name = var.group_name
}

# Add the user "John" to the "Demo-group" IAM group
resource "aws_iam_group_membership" "John_membership" {
  name  = "John-membership"
  users = [aws_iam_user.John.name]
  group = aws_iam_group.Demo-group.name
}

# Create an AWS IAM role named "EC2_Instance_Role"
resource "aws_iam_role" "EC2_Instance_Role" {
  name               = var.role_name
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the policy "Administrator Access" to the "EC2_Instance_Role"
resource "aws_iam_role_policy_attachment" "EC2_Instance_Role_Administrator_Access" {
  role       = aws_iam_role.EC2_Instance_Role.name
  policy_arn = var.policy_arn
}