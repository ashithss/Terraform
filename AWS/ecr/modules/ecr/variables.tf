variable "repository_name" {
    type        = string
    description = "Name of the ECR Repository"  # Description of the variable purpose and usage
}

variable "environment" {
    type        = string
    description = "Name of the environment"  # Description of the variable purpose and usage
}

variable "image_tag_mutability" {
    type        = string
    description = "Tag mutability setting for the repository"  # Description of the variable purpose and usage
    default     = "MUTABLE"  # Default value for the variable if not provided
}

variable "scan_on_push" {
    type        = bool
    description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)"  # Description of the variable purpose and usage
    default     = true  # Default value for the variable if not provided
}

variable "additional_tags" {
    type        = map(string)
    description = "(Optional) A map of tags to assign to the resource."  # Description of the variable purpose and usage
    default     = {}  # Default value for the variable if not provided
}
