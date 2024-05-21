# Terraform AWS SES (Simple Email Service) Configuration

This Terraform script configures AWS SES resources including domain identity, domain identity verification, email identities, and configuration sets.

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
cd terraform-aws-ses
```

Initialize the Terraform working directory:

```
terraform init
```

Customize the variables:

Open the variables.tf file and modify the variables according to your requirements. You can specify the AWS region (aws_region), enable/disable domain (enable_domain), domain name (domain), enable/disable domain verification (enable_domain_verification), email identities (emails), and SES configuration set name (ses_configuration_set_name).

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

## Terraform will create the following AWS resources:

- SES domain identity: Creates an SES domain identity if `enable_domain` is set to `true`. The domain name is specified in the `domain` variable.
- SES domain identity verification: Verifies the SES domain identity if `enable_domain_verification` is set to `true`. The domain identity is retrieved from the created domain identity resource.
- SES email identities: Creates SES email identities based on the email addresses specified in the `emails` variable.
- SES configuration set: Creates an SES configuration set with the specified name (`ses_configuration_set_name`).

Destroy the resources:

If you want to tear down the created resources, run the following command:
```
terraform destroy
```

This will remove all the resources created by Terraform.

## Configuration

The main configuration file for this script is main.tf. It defines the AWS provider and declares the AWS resources to be created.

- Provider: The AWS provider block configures the AWS access credentials and specifies the desired region.

- SES Domain Identity: The aws_ses_domain_identity resource creates an SES domain identity if var.enable_domain is set to true. The domain name is specified in the var.domain variable.

- SES Domain Identity Verification: The aws_ses_domain_identity_verification resource verifies the SES domain identity if var.enable_domain_verification is set to true. The domain identity is retrieved from the created domain identity resource.

- SES Email Identity: The aws_ses_email_identity resource creates SES email identities based on the email addresses specified in the var.emails variable.

- SES Configuration Set: The aws_ses_configuration_set resource creates an SES configuration set with the specified name (var.ses_configuration_set_name).

## Outputs
The outputs section in main.tf defines the following output variables:

- ses_domain_identity: Outputs the domain identity created by the aws_ses_domain_identity resource.

- ses_configuration_set_name: Outputs the name of the SES configuration set created by the aws_ses_configuration_set resource.

- You can use these output values in other Terraform modules or scripts.
