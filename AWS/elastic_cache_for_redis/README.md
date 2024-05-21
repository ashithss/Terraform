# Terraform ElastiCache_for_Redis Script

This folder contains Terraform scripts to create an AWS ElastiCache_for_Redis along with associated resources. The scripts are organized into separate files for better clarity and maintainability.

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

2. Navigate to the `elastic_cache_for_redis
` directory:

```bash

cd devops-templates/elastic_cache_for_redis


```

3. Create a `variables.tf` file with the required variables. For example:


```hcl

variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "redis_subnet1" {
  description = "List of subnet IDs for the DB Db subnet group."
  type        = string
  default     = "subnet-05b1e4eb1345120aa"
}

variable "redis_subnet2" {
  description = "List of subnet IDs for the DB Db subnet group."
  type        = string
  default     = "subnet-0d78b00ecc64088e2"
}

variable "cache_node_type" {
  description = "ElastiCache Redis node type."
  type        = string
  default     = "cache.t2.micro"
}

variable "cluster_id" {
  description = "ElastiCache Redis cluster ID."
  type        = string
  default     = "my-redis-cluster"
}
 

``` 

4. Review and customize the `variables.tf` file to adjust any default values or add new variables as needed.

 
5. Review and customize the `main.tf` file to configure your CloudFront. Comments are provided to guide you through the options.


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
 

To remove the ElastiCache_for_Redis and related resources, you can use:

```bash

terraform destroy

```

## Important Notes

- Ensure that sensitive information such as AWS credentials or secrets are not hardcoded in any of the files. Use environment variables, AWS profiles, or other secure methods to manage credentials.

- Always follow best practices for managing infrastructure as code (IaC) securely.

## Contributing

 

Feel free to customize the content based on your repository structure and any specific instructions you want to provide. This `README.md` file should help visitors understand how to set up and use your ElastiCache_for_Redis Terraform scripts effectively.
