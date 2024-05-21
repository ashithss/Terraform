# S3 Static Website Terraform  Script

 

This folder contains Terraform scripts to create an AWS S3 Static Website along with associated resources. The scripts are organised into separate files for better clarity and maintainability.
## Prerequisites

 

- Terraform CLI installed: [Download and install Terraform](https://www.terraform.io/downloads.html)
- AWS CLI configured with appropriate credentials: [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
## Installation

 

```bash
yum install terraform 
```
## Usage

 

1. Clone this repository to your local machine:

```bash
git clone http://10.16.1.53/devops/devops-templates.git
```

2. Navigate to the `s3_website` directory:

```bash
cd devops-templates/s3_website
```

 

3. Update `variables.tf` file with the required variables. Below is our variables.tf:

 

```hcl
variable "region" {
  type        = string
  description = "The region to use for the S3 bucket"
  default     = "ap-south-1" # Give your desired region
}

variable "bucket_prefix" {
  type        = string
  description = "The prefix to use for the S3 bucket"
  default     = "<s3_bucket_prefix>" # Give your desired s3 bucket prefix name
}

```

 

4. Review and customize the `variables.tf` file to adjust any default values or add new variables as needed.

 

5. Review and customize the `main.tf` file to configure your s3 Static Website. Comments are provided to guide you through the options.

 

6. Initialize the Terraform configuration:

 

```bash
terraform init
```

 

7. Preview the changes that will be applied:

 

```bash
terraform plan
```

 

8. Apply the changes:

 

```bash
terraform apply
```
9. Confirm the changes by typing `yes` when prompted.


## Clean Up

To remove the S3 Static Website and related resources, you can use:
```bash
terraform destroy
```
## Important Notes

- Ensure that sensitive information such as AWS credentials or secrets are not hardcoded in any of the files. Use environment variables, AWS profiles, or other secure methods to manage credentials.
- Always follow best practices for managing infrastructure as code (IaC) securely.
## Contributing
Feel free to customize the content based on your repository structure and any specific instructions you want to provide. This `README.md` file should help visitors understand how to set up and use your CloudFront Terraform scripts effectively.
