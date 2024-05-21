# Route53 zones and records 

Configuration in this directory creates Route53 zones and records for various types of resources - S3 bucket, CloudFront distribution, static records.

Notably, each script file – `main.tf` and `variables.tf` – includes helpful comments. These comments are meant to provide insights and explanations that make it easier to understand how the scripts work. Feel free to review these comments before making any changes or additions to the scripts.
## Prerequisites

- Terraform CLI installed: [Download and install Terraform](https://www.terraform.io/downloads.html)
- AWS CLI configured with appropriate credentials: [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

## Installation of Terraform & Git

*The following commands and steps were executed and tested on AWS Linux machine. Please adapt the commands accordingly, based on the OS (Operating System) you are currently utilizing.*

**1. Update the Package List:**

```bash
sudo yum update -y
```

**2. Download Terraform:**
```bash
wget https://releases.hashicorp.com/terraform/1.5.6/terraform_1.5.6_linux_amd64.zip
```
**3. Extract Terraform:**

```bash
unzip terraform_1.5.6_linux_amd64.zip
```

* Replace the version number (`1.5.6`) with the latest version available on the [Terraform Releases Page](https://releases.hashicorp.com/terraform/).

**4. Move Terraform Executable to a Directory in PATH:**

```bash
sudo mv terraform /usr/local/bin/
```

**5. Verify Installation:**

```bash
terraform version
```
 * After successfully completing the installation of **Terraform**, proceed to install **Git**.

* If **Git** is already installed on your machine, then you can skip the following steps & Go to the **Usage** section below.

**6. Install Git:**

```bash
sudo yum install git -y
```

**7. Verify Installation:**

* To verify that Git has been successfully installed, run the following command:

```bash
git --version
```

* The above command should display the installed **Git** version.

**8. Configure Git:**

* Configure your Git user information using the following commands:

```bash
git config --global user.name "Your Name"
git config --global user.email "your@example.com"
```

* Replace `"Your Name"` with your actual name and `"your@example.com"` with your email address.

**9. Optional: Set Up SSH Key:**

* If you prefer using SSH for Git operations, you can generate and set up an SSH key:

```bash
ssh-keygen -t rsa -b 4096 -C "your@example.com"
```

* Follow the prompts and generate the key. Then, add your public SSH key to your Git service provider (e.g., GitHub, GitLab).

* Remember to replace `"Your Name"` and `"your@example.com"` with your actual information. Make sure you have the necessary permissions to install software on your system

## Usage

**1. Clone this repository to your local machine:**

```bash
git clone http://10.16.1.53/devops/devops-templates.git
```

**2. Navigate to the `route53` directory:**

```bash
cd devops-templates/AWS/cloudwatch
```

* Review and customize the `variables.tf` file to adjust any default values or add new variables as needed.

* Review and customize the `main.tf` file to configure your CloudWatch. Comments are provided to guide you through the options.

**4. Initialize the Terraform configuration:**

```bash
terraform init
```
**5. Preview the changes that will be applied:**

```bash
terraform validate
```

**5. Preview the changes that will be applied:**

```bash
terraform plan
```

**6. Apply the changes:**

```bash
terraform apply
```

**7. Confirm the changes by typing `yes` when prompted.**

## Clean Up

* To remove the CloudWatch and related resources, you can use below command

```bash
terraform destroy
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.49 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.49 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | terraform-aws-modules/cloudfront/aws | n/a |
| <a name="module_delegation_sets"></a> [delegation\_sets](#module\_delegation\_sets) | ./modules/delegation-sets | n/a |
| <a name="module_disabled_records"></a> [disabled\_records](#module\_disabled\_records) | ./modules/records | n/a |
| <a name="module_records"></a> [records](#module\_records) | ./modules/records | n/a |
| <a name="module_records_with_full_names"></a> [records\_with\_full\_names](#module\_records\_with\_full\_names) | ./modules/records | n/a |
| <a name="module_resolver_rule_associations"></a> [resolver\_rule\_associations](#module\_resolver\_rule\_associations) | ./modules/resolver-rule-associations | n/a |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | n/a |
| <a name="module_vpc1"></a> [vpc1](#module\_vpc1) | terraform-aws-modules/vpc/aws | n/a |
| <a name="module_vpc2"></a> [vpc2](#module\_vpc2) | terraform-aws-modules/vpc/aws | n/a |
| <a name="module_zones"></a> [zones](#module\_zones) | ./modules/zones | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_health_check.failover](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check) | resource |
| [aws_route53_resolver_rule.sys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route53_delegation_set_id"></a> [route53\_delegation\_set\_id](#output\_route53\_delegation\_set\_id) | ID of Route53 delegation set |
| <a name="output_route53_delegation_set_name_servers"></a> [route53\_delegation\_set\_name\_servers](#output\_route53\_delegation\_set\_name\_servers) | Name servers in the Route53 delegation set |
| <a name="output_route53_record_fqdn"></a> [route53\_record\_fqdn](#output\_route53\_record\_fqdn) | FQDN built using the zone domain and name |
| <a name="output_route53_record_name"></a> [route53\_record\_name](#output\_route53\_record\_name) | The name of the record |
| <a name="output_route53_resolver_rule_association_id"></a> [route53\_resolver\_rule\_association\_id](#output\_route53\_resolver\_rule\_association\_id) | ID of Route53 Resolver rule associations |
| <a name="output_route53_resolver_rule_association_name"></a> [route53\_resolver\_rule\_association\_name](#output\_route53\_resolver\_rule\_association\_name) | Name of Route53 Resolver rule associations |
| <a name="output_route53_resolver_rule_association_resolver_rule_id"></a> [route53\_resolver\_rule\_association\_resolver\_rule\_id](#output\_route53\_resolver\_rule\_association\_resolver\_rule\_id) | ID of Route53 Resolver rule associations resolver rule |
| <a name="output_route53_zone_name"></a> [route53\_zone\_name](#output\_route53\_zone\_name) | Name of Route53 zone |
| <a name="output_route53_zone_name_servers"></a> [route53\_zone\_name\_servers](#output\_route53\_zone\_name\_servers) | Name servers of Route53 zone |
| <a name="output_route53_zone_zone_arn"></a> [route53\_zone\_zone\_arn](#output\_route53\_zone\_zone\_arn) | Zone ARN of Route53 zone |
| <a name="output_route53_zone_zone_id"></a> [route53\_zone\_zone\_id](#output\_route53\_zone\_zone\_id) | Zone ID of Route53 zone |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
