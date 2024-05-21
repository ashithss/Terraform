# Terraform AWS Secrets Manager Secret Setup

This Terraform script creates an AWS Secrets Manager secret and secret version containing a randomly generated password and an admin username.

## Prerequisites

Before running this Terraform script, make sure you have the following:

- Terraform installed on your local machine.
- AWS credentials with appropriate permissions.
- AWS CLI configured with the desired AWS region.

## Usage

Clone this repository to your local machine:
```
git clone <repository_url>
```
Navigate to the cloned repository:

```
cd terraform-aws-secrets-manager
```

Initialize the Terraform working directory:

```
terraform init
```

Customize the variables:

Open the variables.tf file and modify the variables according to your requirements. You can specify the AWS region (region) and the name of the secret (secret_name).

Validate the format and syntax:

```
terraform validate
```
If everything is validated proceed for planning

Review the execution plan:

Run the following command to see the execution plan:
```
terraform plan
```

This will show you the changes that Terraform will apply to your AWS infrastructure.

Deploy the resources:

If the execution plan looks good, apply the changes:

```
terraform apply
```

Terraform will create the following AWS resources:

- **Secrets Manager secret**: Creates a Secrets Manager secret with the specified name (`secret_name`).
- **Secrets Manager secret version**: Creates a secret version within the secret, containing an admin username and a randomly generated password.
- **Data sources**: Retrieves information about the created secret and secret version.

Destroy the resources:

If you want to tear down the created resources, run the following command:
```
terraform destroy
```

This will remove all the resources created by Terraform.

## Configuration

The main configuration file for this script is main.tf. It defines the AWS provider and declares the AWS resources to be created.

- Provider: The AWS provider block configures the AWS access credentials and specifies the desired region.

- Random Password: The random_password resource generates a random password with a length of 16 characters and includes special characters defined in the override_special variable.

- Secrets Manager Secret: The aws_secretsmanager_secret resource creates a Secrets Manager secret with the specified name (var.secret_name).

- Secrets Manager Secret Version: The aws_secretsmanager_secret_version resource creates a secret version within the secret, containing an admin username and the randomly generated password.

- Data Sources: The data blocks retrieve information about the created secret and secret version.

## Variables
The variables for this script are defined in the variables.tf file. You can modify these variables to customize the Secrets Manager secret setup:

- **region**: The AWS region where the Secrets Manager secret will be created.
- **secret_name**: The name of the Secrets Manager secret
