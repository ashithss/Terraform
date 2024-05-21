## Prerequisites: 

Before proceeding with the deployment, ensure that you have the following prerequisites:

An AWS account with appropriate access and permissions.
Terraform installed on your local machine.
Steps:

Follow the steps below to deploy the AWS infrastructure:

Create a new directory for your project and navigate to it using the command line.

Initialize the Terraform project by running the following command:
```
terraform init
```
Create a new Terraform configuration file, e.g., main.tf, variables.tf output.tf and copy the code provided below into the file.

Open the configuration file and update the variables as needed. The variables are specified in the var block at the top of the file.

Save the configuration file.

Run the following command to validate the Terraform configuration:
```
terraform validate
```

If the validation is successful, run the following command to plan the infrastructure deployment:
```
terraform plan
```
Review the planned changes and ensure they align with your requirements.

If everything looks good, run the following command to apply the changes and deploy the infrastructure:
```
terraform apply
```
Confirm the deployment by typing **"yes"** when prompted.

Wait for the Terraform deployment to complete. The output will indicate the status of each resource.

Once the deployment is finished, you can verify the created resources in your AWS account.

Resources
The following AWS resources will be created by the provided Terraform configuration:

Terraform will create the following AWS resources:

- **ACM certificate**: Creates an ACM certificate with the specified domain name (`domain_name`) and validation method as "DNS".
- **Route53 zone**: Creates a Route53 zone for the specified domain name (`route53_domain_name`).
- **ACM certificate validation**: Validates the ACM certificate using DNS validation. Creates validation records in Route53 based on the certificate's domain validation options.
- **Route53 record**: Creates Route53 records for DNS validation. The records are created based on the domain validation options of the ACM certificate.


## Configuration

The main configuration file for this script is main.tf. It defines the AWS provider and declares the AWS resources to be created.

- Provider: The AWS provider block configures the AWS access credentials and specifies the desired region.

- ACM Certificate: The aws_acm_certificate resource creates an ACM certificate with the specified domain name (var.domain_name) and validation method as "DNS". The create_before_destroy lifecycle block ensures that the new certificate is created before the existing one is destroyed.

- Route53 Zone: The aws_route53_zone resource creates a Route53 zone for the specified domain name (var.route53_domain_name).

- ACM Certificate Validation: The aws_acm_certificate_validation resource validates the ACM certificate using DNS validation. It retrieves the certificate ARN from the created ACM certificate resource and obtains the validation record FQDNs from the domain validation options.

- Route53 Record: The aws_route53_record resource creates Route53 records for DNS validation. The resource iterates over the domain validation options of the ACM certificate and creates records based on the resource record name, type, TTL, and value.
