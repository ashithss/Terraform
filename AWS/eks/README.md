# Terraform AWS EKS Script

This folder contains Terraform scripts designed to set up an AWS EKS and related resources. To keep things organized, the scripts are split into different files for better clarity and easier maintenance.

Notably, each script file – `main.tf`, `terraform.tfvars`, `provider.tf` and `variables.tf` – includes helpful comments. These comments are meant to provide insights and explanations that make it easier to understand how the scripts work. Feel free to review these comments before making any changes or additions to the scripts.

## Modules

The modules folder in this repository contains 2 folders :

**1. eks:**
- `output.tf`: This file defines the output values that are useful for displaying information about the created EKS repository.

- `eks.tf`: This Terraform script defines the resources required for creating an AWS EKS repository. It includes configurations for repository name, environment, and tag mutability.

- `variables.tf`: This file defines the input variables used in the eks.tf script. You can customize these variables based on your requirements.

**2. sg_eks:**
- `sg.tf`: This Terraform script defines an AWS security group resource named "worker_node_sg" for allowing SSH inbound traffic. The security group is associated with a specific VPC.

- `variables.tf`: This file defines the input variables used in the eks.tf script. You can customize these variables based on your requirements.
- `output.tf`: This file defines the output values that are useful for displaying information about the created EKS repository.

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

**2. Navigate to the `eks` directory:**

```bash
cd devops-templates/AWS/eks
```

**3. Update `variables.tf` file with the required variables. Below is our `variables.tf` file:**

```hcl
# This variable is used to specify the AWS region where the resources will be created
variable "location" {
  default = "<region>"
}
# This variable is used to specify the Amazon Machine Image (AMI) ID for the EC2 instance
variable "os_name" {
  default = "<ami_id>"
}
# This variable is used to specify the key pair name for accessing the EC2 instance
variable "key" {
  default = "<key_name>"
}
# This variable is used to specify the instance type for the EC2 instance
variable "instance-type" {
  default = "<instance_type>"
}
# This variable is used to specify the CIDR block for the VPC
variable "vpc-cidr" {
  default = "10.10.0.0/16"  
}
# This variable is used to specify the CIDR block for subnet 1
variable "subnet1-cidr" {
  default = "10.10.1.0/24"
}
# This variable is used to specify the CIDR block for subnet 2
variable "subnet2-cidr" {
  default = "10.10.2.0/24"
}
# This variable is used to specify the availability zone for subnet 1
variable "subent_az" {
  default =  "ap-south-1a"  
}
# This variable is used to specify the availability zone for subnet 2
variable "subent-2_az" {
  default =  "ap-south-1b"  
}
```

* Review and customize the `main.tf` file to configure your EKS. Comments are provided to guide you through the options.

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

* To remove the EKS and related resources, you can use below command

```bash
terraform destroy
```

## Important Notes

- Ensure that sensitive information such as AWS credentials or secrets are not hardcoded in any of the files. Use environment variables, AWS profiles, or other secure methods to manage credentials.
- Always follow best practices for managing infrastructure as code (IaC) securely.

## Contributing

Feel free to customize the content based on your repository structure and any specific instructions you want to provide. This `README.md` file should help visitors understand how to set up and use your EKS Terraform scripts effectively.
