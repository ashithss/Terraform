# Configure the AWS provider with the specified region
provider "aws" {
  region = var.region
}

# Generate a random password
resource "random_password" "password" {
  length           = 16     # The length of the password
  special          = true   # Include special characters in the password
  override_special = "_%@"  # Specify additional special characters to include in the password
}

# Create an AWS Secrets Manager secret
resource "aws_secretsmanager_secret" "secretmasterDB" {
  name = var.secret_name  # The name of the Secrets Manager secret
}

# Store the secret version in AWS Secrets Manager
resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id     = aws_secretsmanager_secret.secretmasterDB.id  # The ID of the Secrets Manager secret
  secret_string = jsonencode({  # The secret string to store
    "username": "adminaccount",
    "password": random_password.password.result
  })
}

# Import the existing AWS Secrets Manager secret
data "aws_secretsmanager_secret" "imported_secretmasterDB" {
  arn = aws_secretsmanager_secret.secretmasterDB.arn  # The ARN of the existing Secrets Manager secret
}

# Import the existing AWS Secrets Manager secret version
data "aws_secretsmanager_secret_version" "imported_creds" {
  secret_id = data.aws_secretsmanager_secret.imported_secretmasterDB.arn  # The ARN of the existing Secrets Manager secret
}

# Decode the secret string into local variables
locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.imported_creds.secret_string)
}
