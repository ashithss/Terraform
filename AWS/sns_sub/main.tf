# Configure the AWS provider with the specified region
provider "aws" {
  region = var.aws_region  # Set the AWS region from the input variable
}

# Create an AWS SNS topic for the pipeline
resource "aws_sns_topic" "pipeline_topic" {
  name = var.topic_name  # Set the name for the SNS topic from the input variable
}

# Conditionally create SNS email subscriptions based on enable_subscribers variable
resource "aws_sns_topic_subscription" "pipeline_email_subscribers" {
  count      = var.enable_subscribers ? length(var.subscriber_emails) : 0  # Conditionally create the resource based on the value of enable_subscribers variable
  topic_arn  = aws_sns_topic.pipeline_topic.arn  # Set the ARN of the SNS topic
  protocol   = "email"  # Set the protocol to "email" for email subscriptions
  endpoint   = element(var.subscriber_emails, count.index)  # Set the email endpoint from the input variable
}

# Conditionally create SNS SMS subscriptions based on enable_subscribers variable
resource "aws_sns_topic_subscription" "pipeline_sms_subscribers" {
  count      = var.enable_subscribers ? length(var.subscriber_phones) : 0  # Conditionally create the resource based on the value of enable_subscribers variable
  topic_arn  = aws_sns_topic.pipeline_topic.arn  # Set the ARN of the SNS topic
  protocol   = "sms"  # Set the protocol to "sms" for SMS subscriptions
  endpoint   = element(var.subscriber_phones, count.index)  # Set the phone number endpoint from the input variable
}
