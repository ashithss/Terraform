# This block defines variables used within the Terraform configuration.
variable "aws_region" {
  description = "AWS region" # Describes the purpose of the `aws_region` variable
  type        = string # Specifies the data type of the variable as string
}

variable "user_pool_name" {
  description = "Name of the Cognito user pool" # Describes the purpose of the `user_pool_name` variable
  type        = string # Specifies the data type of the variable as string
}

variable "allow_admin_create_user_only" {
  description = "Allow only admin to create users" # Describes the purpose of the `allow_admin_create_user_only` variable
  type        = bool # Specifies the data type of the variable as boolean
  default     = false # Sets the default value for the variable to `false`
}

variable "minimum_password_length" {
  description = "Minimum password length" # Describes the purpose of the `minimum_password_length` variable
  type        = number # Specifies the data type of the variable as number
  default     = 8 # Sets the default value for the variable to `8`
}

variable "require_lowercase" {
  description = "Require lowercase characters in password" # Describes the purpose of the `require_lowercase` variable
  type        = bool # Specifies the data type of the variable as boolean
  default     = true # Sets the default value for the variable to `true`
}

variable "require_uppercase" {
  description = "Require uppercase characters in password" # Describes the purpose of the `require_uppercase` variable
  type        = bool # Specifies the data type of the variable as boolean
  default     = true # Sets the default value for the variable to `true`
}

variable "require_numbers" {
  description = "Require numbers in password" # Describes the purpose of the `require_numbers` variable
  type        = bool # Specifies the data type of the variable as boolean
  default     = true # Sets the default value for the variable to `true`
}

variable "require_symbols" {
  description = "Require symbols in password" # Describes the purpose of the `require_symbols` variable
  type        = bool # Specifies the data type of the variable as boolean
  default     = false # Sets the default value for the variable to `false`
}

variable "username" {
  description = "Username for the Cognito user" # Describes the purpose of the `username` variable
  type        = string # Specifies the data type of the variable as string
}

variable "email" {
  description = "Email for the Cognito user" # Describes the purpose of the `email` variable
  type        = string # Specifies the data type of the variable as string
}

variable "password" {
  description = "Temporary password for the Cognito user" # Describes the `password` variable
  type        = string # Specifies the data type of the variable as string
}
