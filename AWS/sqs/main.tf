provider "aws" {
  region = "us-east-1" # Change this to your desired region
}

resource "aws_sqs_queue" "main_queue" {
  name = var.queue_name

  # Enable the dead-letter queue configuration if enabled
  redrive_policy = var.enable_dead_letter_queue ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue.arn,
    maxReceiveCount     = 3,
  }) : null
}

# Create a dead-letter queue if enabled
resource "aws_sqs_queue" "dead_letter_queue" {
  name = "${var.queue_name}-dead-letter"

  # Additional configuration for the dead-letter queue if needed
}

# Define an IAM policy for allowing necessary actions on the SQS queue
resource "aws_iam_policy" "sqs_policy" {
  name = "sqs-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "sqs:GetQueueUrl",
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          # Add other actions here if needed
        ],
        Resource = aws_sqs_queue.main_queue.arn,
      },
      # Additional statements if needed
    ],
  })
}

# Attach the SQS policy to a new IAM role
resource "aws_iam_role" "sqs_role" {
  name = "sqs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "sqs.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "sqs_policy_attachment" {
  policy_arn = aws_iam_policy.sqs_policy.arn
  role       = aws_iam_role.sqs_role.name
}
