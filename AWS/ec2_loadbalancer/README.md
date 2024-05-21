# Terraform EC2_LoadBalancer Script

This folder contains Terraform scripts to create an AWS EC2_LoadBalancer along with associated resources. The scripts are organized into separate files for better clarity and maintainability.
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

2. Navigate to the `ec2_loadbalancer` directory:

```bash
cd devops-templates/ec2_loadbalancer
```

3. Create a `variables.tf` file with the required variables. For example:


```hcl
variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "instance_ami" {
  description = "The ID of the EC2 instance AMI."
  type        = string
  default = "ami-053b0d53c279acc90"
  
}

variable "instance_type" {
  description = "The type of EC2 instance."
  type        = string
  default     = "t2.micro"
}

variable "subnets" {
  description = "List of subnet IDs for the load balancer."
  type        = list(string)
  default     = ["subnet-05b1e4eb1345120aa", "subnet-0d78b00ecc64088e2"]


}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
  default     = "vpc-0e54585d1c94c3e51"

}

```

4. Review and customize the `variables.tf` file to adjust any default values or add new variables as needed.


5. Review and customize the `main.tf` file to configure your EC2_LoadBalancer. Comments are provided to guide you through the options.


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
 

To remove the EC2_LoadBalancer and related resources, you can use:

 ```bash
terraform destroy
```

## Important Notes

 
- Ensure that sensitive information such as AWS credentials or secrets are not hardcoded in any of the files. Use environment variables, AWS profiles, or other secure methods to manage credentials.
- Always follow best practices for managing infrastructure as code (IaC) securely.
## Contributing

 

Feel free to customize the content based on your repository structure and any specific instructions you want to provide. This `README.md` file should help visitors understand how to set up and use your EC2_LoadBalancer
 Terraform scripts effectively.
