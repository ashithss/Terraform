# AWS Terraform Code

## Requirements
- Terraform
- AWS provider

## Installation

1. Clone this repository:
    ```
    git clone https://github.com/ashithss/Terraform.git
    cd Terraform/AWS
    ```

2. Update the variables in `examples/terraform.tfvars` based on your requirements.

3. Initialize the Terraform directory:
    ```
    terraform init
    ```

4. Validate the Terraform configuration files:
    ```
    terraform validate
    ```

5. Generate and show an execution plan:
    ```
    terraform plan
    ```

6. Apply the desired changes to reach the expected infrastructure state:
    ```
    terraform apply -var-file=./examples/terraform.tfvars
    ```

7. If you want to destroy the Terraform-managed infrastructure:
    ```
    terraform destroy
    ```



# Directory Structure

```bash
├── api_gateway_lamba_functions
│   ├── lambda_function.zip
│   ├── main.tf
│   ├── output.tf
│   ├── readme.md
│   ├── terraform.tfvars
│   └── variables.tf
├── app_Mesh
│   ├── main.tf
│   ├── output.tf
│   ├── readme.md
│   ├── variables.tf
│   └── version.tf
├── aws_msk
│   ├── main.tf
│   ├── output.tf
│   ├── readme.md
│   ├── var.tf
│   └── versions.tf
├── certficate_manager
│   ├── main.tf
│   ├── output.tf
│   ├── readme.md
│   ├── terraform.tfvars
│   └── variables.tf
├── cloudfront
│   ├── main.tf
│   ├── README.md
│   ├── terraform.tfvars
│   └── variables.tf
├── cloudtrail
│   ├── main.tf
│   ├── README.md
│   ├── terraform.tfvars
│   └── variables.tf
├── cloudwatch
│   ├── main.tf
│   ├── README.md
│   ├── terraform.tfvars
│   └── variables.tf
├── codepipeline
│   ├── CODE_OF_CONDUCT.md
│   ├── CONTRIBUTING.md
│   ├── data.tf
│   ├── examples
│   │   └── terraform.tfvars
│   ├── LICENSE
│   ├── locals.tf
│   ├── main.tf
│   ├── modules
│   │   ├── codebuild
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── README.md
│   │   │   └── variables.tf
│   │   ├── codecommit
│   │   │   ├── data.tf
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── README.md
│   │   │   └── variables.tf
│   │   ├── codepipeline
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── README.md
│   │   │   └── variables.tf
│   │   ├── iam-role
│   │   │   ├── data.tf
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── README.md
│   │   │   └── variables.tf
│   │   ├── kms
│   │   │   ├── data.tf
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── README.md
│   │   │   └── variables.tf
│   │   └── s3
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── provider.tf
│   │       ├── README.md
│   │       └── variables.tf
│   ├── outputs.tf
│   ├── README.md
│   ├── templates
│   │   ├── buildspec_apply.yml
│   │   ├── buildspec_destroy.yml
│   │   ├── buildspec_plan.yml
│   │   ├── buildspec_validate.yml
│   │   └── scripts
│   │       └── tf_ssp_validation.sh
│   └── variables.tf
├── cognito
│   ├── main.tf
│   ├── README.md
│   ├── terraform.tfvars
│   └── variables.tf
├── ebs
│   ├── main.tf
│   ├── outputs.tf
│   ├── readme.md
│   └── variables.tf
├── ec2_creation
│   ├── main.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── README.md
│   └── variables.tf
├── ec2_loadbalancer
│   ├── main.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── README.md
│   └── variables.tf
├── ec2_loadbalancer_autoscaling
│   ├── main.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── README.md
│   └── variables.tf
├── ecr
│   ├── main.tf
│   ├── modules
│   │   └── ecr
│   │       ├── ecr.tf
│   │       ├── output.tf
│   │       └── variables.tf
│   ├── provider.tf
│   ├── README.md
│   ├── terraform.tfvars
│   └── variables.tf
├── ecs
│   ├── alb.tf
│   ├── asg.tf
│   ├── container-definitions
│   │   └── container-def.json
│   ├── ecs.tf
│   ├── iam.tf
│   ├── main.tf
│   ├── output.tf
│   ├── README.md
│   ├── variables.tf
│   └── vpc.tf
├── eks
│   ├── main.tf
│   ├── modules
│   │   ├── eks
│   │   │   ├── eks.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   └── sg_eks
│   │       ├── output.tf
│   │       ├── sg.tf
│   │       └── variables.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── README.md
│   └── variables.tf
├── elastic_cache_for_redis
│   ├── main.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── README.md
│   └── variables.tf
├── iam
│   ├── main.tf
│   ├── readme.md
│   └── variables.tf
├── lambda
│   ├── main.tf
│   ├── outputs.tf
│   ├── readme.md
│   ├── variables.tf
│   └── versions.tf
├── mysql_rds
│   ├── main.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── README.md
│   └── variables.tf
├── postgressql_rds
│   ├── main.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── README.md
│   └── variables.tf
├── README.md
├── redshift
│   ├── cluster.tf
│   ├── iam.tf
│   ├── main.tf
│   ├── output.tf
│   ├── readme.md
│   ├── secret-manager.tf
│   ├── terraform.tfvars
│   ├── variable.tf
│   └── vpc.tf
├── route53
│   ├── main.tf
│   ├── modules
│   │   ├── delegation-sets
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── README.md
│   │   │   ├── variables.tf
│   │   │   └── versions.tf
│   │   ├── records
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── README.md
│   │   │   ├── variables.tf
│   │   │   └── versions.tf
│   │   ├── resolver-rule-associations
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── README.md
│   │   │   ├── variables.tf
│   │   │   └── versions.tf
│   │   └── zones
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── README.md
│   │       ├── variables.tf
│   │       └── versions.tf
│   ├── outputs.tf
│   ├── README.md
│   ├── variables.tf
│   └── versions.tf
├── s3_bucket_creation
│   ├── main.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── README.md
│   ├── uploads
│   │   ├── cat.jpg
│   │   └── test
│   └── variables.tf
├── s3_website
│   ├── main.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── README.md
│   ├── uploads
│   │   ├── error.html
│   │   └── index.html
│   └── variables.tf
├── secrete_manager
│   ├── example-secrete-manager-rds&pgsql
│   │   ├── main.tf
│   │   ├── readme.md
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── main.tf
│   ├── output.tf
│   ├── readme.md
│   ├── terraform.tfvars
│   └── variables.tf
├── ses
│   ├── main.tf
│   ├── output.tf
│   ├── readme.md
│   ├── send_email.py
│   ├── terraform-ses-working-main
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── send_email.py
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── terraform.tfvars
│   └── variables.tf
├── sns_sub
│   ├── main.tf
│   ├── output.tf
│   ├── README.md
│   ├── terraform.tfvars
│   └── variables.tf
├── sqs
│   ├── main.tf
│   ├── readme.md
│   └── variables.tf
├── transit_gateway
│   ├── main.tf
│   ├── readme.md
│   └── variables.tf
└── vpc
    ├── main.tf
    ├── output.tf
    ├── readme.md
    ├── terraform.tfvars
    └── variables.tf

57 directories, 236 files

```