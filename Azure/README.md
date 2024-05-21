# AWS Terraform Code

## Requirements
- Terraform
- AZURE provider

## Installation

1. Clone this repository:
    ```
    git clone https://github.com/ashithss/Terraform.git
    cd Terraform/Azure
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
.
├── azure-ad
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── Readme.md
│   └── variables.tf
├── azure-adf
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── Readme.md
│   └── variables.tf
├── azure-aks
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── Readme.md
│   ├── terraform.tfvars
│   └── variables.tf
├── azure-autoscaling
│   ├── main.tf
│   ├── providers.tf
│   ├── Readme.md
│   ├── terraform.tfvars
│   └── variables.tf
├── azure-cdn
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── Readme.md
│   ├── terraform.tfvars
│   └── variables.tf
├── azure-cosmos
│   ├── cassandra
│   │   └── main.tf
│   ├── Gremlin
│   │   ├── main.tf
│   │   └── providers.tf
│   ├── Mongo
│   │   └── main.tf
│   ├── Nosql
│   │   ├── main.tf
│   │   └── providers.tf
│   ├── Readme.md
│   └── table
│       └── main.tf
├── azure-dns
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── Readme.md
│   ├── terraform.tfvars
│   └── variables.tf
├── azure-eventhub
│   ├── main.tf
│   ├── providers.tf
│   ├── Readme.md
│   └── variables.tf
├── azure-keyvault
│   ├── main.tf
│   ├── providers.tf
│   ├── Readme.md
│   ├── terraform.tfvars
│   └── variables.tf
├── azure-lb
│   ├── main.tf
│   ├── output.tf
│   ├── providers.tf
│   ├── Readme.md
│   ├── terraform.tfvars
│   └── variables.tf
├── azure-network
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── Readme.md
│   ├── terraform.tfvars
│   └── variables.tf
├── azure-postgressfbdb
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── Readme.md
│   └── variables.tf
├── azure-redis
│   ├── basic
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   └── variables.tf
│   ├── premium-with-backup
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   └── variables.tf
│   ├── premium-with-clustering
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   └── variable.tf
│   ├── Readme.md
│   └── standard
│       ├── main.tf
│       ├── provider.tf
│       └── variables.tf
├── azure-servicebusnamespace
│   ├── main.tf
│   ├── providers.tf
│   ├── Readme.md
│   ├── terraform.tfvars
│   └── variables.tf
├── azure-sql
│   └── server
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── Readme.md
│       ├── terraform.tfvars
│       └── variables.tf
├── azure-storage
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── Readme.md
│   ├── terraform.tfvars
│   └── variables.tf
├── azure-vm
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── Readme.md
│   ├── terraform.tfvars
│   └── variables.tf
├── README.md
└── Terraform.gitignore

28 directories, 105 files
