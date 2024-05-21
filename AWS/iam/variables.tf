# The AWS region to be used
variable "region" {
  default = "<desired_region>"
}

# The name of the AWS IAM user
variable "user_name" {
  default = "<desired_user_name>"
}

# The name of the AWS IAM group
variable "group_name" {
  default = "desired_group_name"
}

# The name of the AWS IAM role
variable "role_name" {
  default = "EC2_Instance_Role"
}

# The ARN (Amazon Resource Name) of the policy to be attached
variable "policy_arn" {
  default = "arn:aws:iam::aws:policy/AdministratorAccess"
}
# Give your desired policy ARN
