# This block specifies the provider for the AWS resources being used.
provider "aws" {
  region = var.aws_region
}

# This block defines the creation of an AWS Cognito user pool.
resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name

  # This block configures user creation by admins.
  admin_create_user_config {
    allow_admin_create_user_only = var.allow_admin_create_user_only
  }

  # This block defines the password policy for user passwords.
  password_policy {
    minimum_length  = var.minimum_password_length
    require_lowercase = var.require_lowercase
    require_uppercase = var.require_uppercase
    require_numbers   = var.require_numbers
    require_symbols   = var.require_symbols
  }
}

# This block defines an output that exposes the user pool ID.
output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

# This block defines a local-exec provisioner to execute an external script
resource "null_resource" "create_cognito_user" {
  provisioner "local-exec" {
    command = <<-EOT
      aws cognito-idp admin-create-user \
        --user-pool-id ${aws_cognito_user_pool.user_pool.id} \
        --username ${var.username} \
        --user-attributes Name=email,Value=${var.email} \
        --temporary-password ${var.password} \
        --message-action SUPPRESS
    EOT
  }

  depends_on = [aws_cognito_user_pool.user_pool]
}
