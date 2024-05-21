# Terraform RDS_PostgreSQL_Database Script

This folder contains Terraform scripts to create an AWS RDS_PostgreSQL_Database along with associated resources. The scripts are organized into separate files for better clarity and maintainability.

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

2. Navigate to the `postgressql_rds` directory:

 ```bash

cd devops-templates/postgressql_rds

```

3. Create a `variables.tf` file with the required variables. For example: 

```hcl

variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "rds_subnet1" {
  description = "List of subnet IDs for the DB Db subnet group."
  type        = string
  default     = "subnet-05b1e4eb1345120aa"
}

variable "rds_subnet2" {
  description = "List of subnet IDs for the DB Db subnet group."
  type        = string
  default     = "subnet-0d78b00ecc64088e2"
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
  default     = "vpc-0e54585d1c94c3e51" 
}

variable "db_instance" {
  description = "Instance class for the DB instance."
  type        = string
  default     = "db.t2.micro"
}

variable "allocated_storage" {
  description = "The amount of allocated storage for the DB instance, in gigabytes."
  type        = number
  default     = 20
}

variable "engine_version" {
  description = "DB engine version for MySQL."
  type        = string
  default     = "5.7"
}

variable "username" {
  description = "Username for the DB instance."
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Password for the DB instance."
  type        = string
  default     = "admin123"
}

variable "backup_retention_period" {
  description = "The number of days for which automated backups are retained."
  type        = number
  default     = 35
}

variable "backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled."
  type        = string
  default     = "22:00-23:00"
}
 

``` 

4. Review and customize the `variables.tf` file to adjust any default values or add new variables as needed.
 
5. Review and customize the `main.tf` file to configure your RDS_PostgreSQL_Database. Comments are provided to guide you through the options.
 
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

To remove the RDS_PostgreSQL_Database and related resources, you can use: 

```bash

terraform destroy

```

## Important Notes

- Ensure that sensitive information such as AWS credentials or secrets are not hardcoded in any of the files. Use environment variables, AWS profiles, or other secure methods to manage credentials.

- Always follow best practices for managing infrastructure as code (IaC) securely.

## Contributing

 

Feel free to customize the content based on your repository structure and any specific instructions you want to provide. This `README.md` file should help visitors understand how to set up and use your RDS_PostgreSQL_Database Terraform scripts effectively.
