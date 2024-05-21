resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.repository_name  # Name of the ECR repository
  image_tag_mutability = var.image_tag_mutability  # Tag mutability setting for the repository

  image_scanning_configuration {
    scan_on_push = var.scan_on_push  # Indicates whether images are scanned after being pushed to the repository
  }

  tags = merge(
    var.additional_tags,  # Merges any additional tags provided in the `additional_tags` variable
    {
      ManagedBy   = "Terraform"  # Adds a tag indicating that the repository is managed by Terraform
      Environment = "${var.environment}"  # Adds a tag indicating the environment associated with the repository
    }
  )
}
