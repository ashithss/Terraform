# Terraform AWS CloudWatch Script

This folder contains Terraform scripts designed to set up an AWS CloudWatch and related resources. To keep things organized, the scripts are split into different files for better clarity and easier maintenance.

Notably, each script file – `main.tf`, `terraform.tfvars`, and `variables.tf` – includes helpful comments. These comments are meant to provide insights and explanations that make it easier to understand how the scripts work. Feel free to review these comments before making any changes or additions to the scripts.
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

**2. Navigate to the `cloudwatch` directory:**

```bash
cd devops-templates/AWS/cloudwatch
```

**3. Update `terraform.tfvars` file with the required variables. Below is our terraform.tfvars file:**

```hcl
# aws_access_key = "<your-access-key>" # Provide your access key(Not required as we are creating resources in same account)
# aws_secret_key = "<your-secret-key>" # Provide your secret key(Not required as we are creating resources in same account)
log_group_name = "<your-log-group-name>" # Give your desired log group name
```

* Review and customize the `variables.tf` file to adjust any default values or add new variables as needed.

* Review and customize the `main.tf` file to configure your CloudWatch. Comments are provided to guide you through the options.

**4. Initialize the Terraform configuration:**

```bash
terraform init
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

## Important Notes

- Ensure that sensitive information such as AWS credentials or secrets are not hardcoded in any of the files. Use environment variables, AWS profiles, or other secure methods to manage credentials.
- Always follow best practices for managing infrastructure as code (IaC) securely.

## Contributing

Feel free to customize the content based on your repository structure and any specific instructions you want to provide. This `README.md` file should help visitors understand how to set up and use your CloudWatch Terraform scripts effectively.
