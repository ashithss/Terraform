# Terraform Azure keyvault

This folder contains Terraform scripts to create an Azure keyvault along with associated resources. The scripts are organized into separate files for better clarity and maintainability.
## Prerequisites

- Terraform CLI installed: [Download and install Terraform](https://www.terraform.io/downloads.html)
- Azure CLI configured with appropriate credentials: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
## Installation of Terraform on Linux Machine


1. Update the Package List:


```bash
sudo yum update -y
```

2. Download and Extract Terraform:


```bash
wget https://releases.hashicorp.com/terraform/1.0.8/terraform_1.0.8_linux_amd64.zip
unzip terraform_1.0.8_linux_amd64.zip
```

Replace the version number (`1.0.8`) with the latest version available on the [Terraform Releases Page](https://releases.hashicorp.com/terraform/).


3. Move Terraform Executable to a Directory in PATH:
```bash
sudo mv terraform /usr/local/bin/
```
4. Verify Installation:

```bash
terraform version
```
## Usage


1. Clone this repository to your local machine:

```bash
git clone http://10.16.1.53/devops/devops-templates.git
```

2. Navigate to the `azure-keyvault` directory:

```bash
cd devops-templates/azure-keyvault
```

3. Update `terraform.tfvars` file with the required variables. Below is our terraform.tfvars file:

```hcl
resource group name = "<rg_name>" #update resource group name
location = "<region>" # Update with your desired region
name = "<name>" # name
```

4. Review and customize the `variables.tf` file to adjust any default values or add new variables as needed.


5. Review and customize the `main.tf` file to configure AKS. Comments are provided to guide you through the options.

 

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

To remove the Azure keyvault and related resources, you can use:


```bash
terraform destroy
```

 

## Important Notes

 

- Ensure that sensitive information such as Azure tenant id or client id or secrets are not hardcoded in any of the files. Use environment variables, Key vaults profiles, or other secure methods to manage credentials.
- Always follow best practices for managing infrastructure as code (IaC) securely.
## Contributing

 

Feel free to customize the content based on your repository structure and any specific instructions you want to provide. This `README.md` file should help visitors understand how to set up and use your keyvault Terraform scripts effectively.


has context menu
Compose