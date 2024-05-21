# This variable is used to specify the name for the SSH key used for aws_launch_configuration
variable "key_name" {
  type        = string
  description = "The name for the SSH key, used for aws_launch_configuration"
  default     = "<key_name>"
}

variable "cluster_name" {
  type        = string
  description = "The name of AWS ECS cluster"
  default     = "terraform_workshop_cluster"
}
