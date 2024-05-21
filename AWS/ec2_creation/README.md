# Terraform EC2_Creation Script

This folder contains Terraform scripts to create an AWS EC2_Creation along with associated resources. The scripts are organized into separate files for better clarity and maintainability.
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

2. Navigate to the `ec2_creation` directory:

 
```bash
cd devops-templates/ec2_creation
```

3. Create a `variables.tf` file with the required variables. For example:


```hcl
variable "aws_region" {
  description = "AWS region for resources"
  default = "us-east-1"
}

variable "instance_ami" {
  description = "AMI ID for the instance"
  default = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  description = "Instance type for the instance"
  default = "t2.micro"
}

variable "security_group_ingress_cidr" {
  description = "CIDR block for security group ingress"
  default = "0.0.0.0/0"
}

variable "keypair_name" {
  description = "Name of the EC2 key pair"
  default = "keypair1.pem"
}

variable "volume_size" {
  description = "Size of the EBS volume in GiB"
  default = 10
}
```
 
4. Review and customize the `variables.tf` file to adjust any default values or add new variables as needed.


5. Review and customize the `main.tf` file to configure your EC2_Creation. Comments are provided to guide you through the options.


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

 
To remove the EC2_Creation and related resources, you can use:

```bash
terraform destroy
``` 

## Important Notes
 

- Ensure that sensitive information such as AWS credentials or secrets are not hardcoded in any of the files. Use environment variables, AWS profiles, or other secure methods to manage credentials.
- Always follow best practices for managing infrastructure as code (IaC) securely.
## Contributing

 
Feel free to customize the content based on your repository structure and any specific instructions you want to provide. This `README.md` file should help visitors understand how to set up and use your EC2_Creation Terraform scripts effectively.
