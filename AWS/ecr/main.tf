This line declares a new module block named "ecr". Modules in Terraform allow you to encapsulate and reuse groups of resources.
module "ecr" {
  source = "./modules/ecr"  // Source location of the ECR module

  repository_name = var.repository_name  // Name of the ECR repository
  image_tag_mutability = var.image_tag_mutability  // Tag mutability setting for the repository
  environment = var.environment  // Environment tag for the repository
}
