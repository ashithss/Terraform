# Configure the AWS provider with the specified region
provider "aws" {
  region = var.aws_region  # Set the AWS region from the input variable
}

# Create an AWS SES domain identity if enabled
resource "aws_ses_domain_identity" "default" {
  count  = var.enable_domain ? 1 : 0  # Conditionally create the resource based on the value of enable_domain variable
  domain = var.domain  # Set the domain for the SES domain identity
}

# Verify the AWS SES domain identity if enabled
resource "aws_ses_domain_identity_verification" "default" {
  count  = var.enable_domain_verification ? 1 : 0  # Conditionally create the resource based on the value of enable_domain_verification variable
  domain = aws_ses_domain_identity.default[0].domain  # Retrieve the domain from the previously created SES domain identity resource
}

# Create AWS SES email identities
resource "aws_ses_email_identity" "default" {
  count = length(var.emails)  # Create multiple email identities based on the number of emails provided in the input variable
  email = var.emails[count.index]  # Set the email address for each SES email identity from the input variable
}

# Create an AWS SES configuration set
resource "aws_ses_configuration_set" "default" {
  name = var.ses_configuration_set_name  # Set the name for the SES configuration set from the input variable
}

# Output the SES domain identity
output "ses_domain_identity" {
  value = aws_ses_domain_identity.default[0].domain  # Output the domain of the SES domain identity resource
}

# Output the SES configuration set name
output "ses_configuration_set_name" {
  value = aws_ses_configuration_set.default.name  # Output the name of the SES configuration set resource
}
