# Terraform AWS VPC Infrastructure

This Terraform script creates an AWS VPC (Virtual Private Cloud) infrastructure with public and private subnets, internet and NAT gateways, routing tables, and route table associations. It uses the AWS provider from HashiCorp.

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
cd terraform-aws-vpc
```

Initialize the Terraform working directory:

```
terraform init
```

Customize the variables:

Open the variables.tf file and modify the variables according to your requirements. You can specify the VPC CIDR block, AWS region, availability zones, and other parameters.

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

Deploy the infrastructure:

If the execution plan looks good, apply the changes:

```
terraform apply
```
Terraform will create the VPC, subnets, gateways, and routing tables in your AWS account.

Destroy the infrastructure:

If you want to tear down the created infrastructure, run the following command:
```
terraform destroy
```

This will remove all the resources created by Terraform.

## Configuration
The main configuration file for this script is **main.tf**. It defines the AWS provider and declares the AWS resources to be created.

- **Provider**: The AWS provider block configures the AWS access credentials and specifies the desired region.

- **VPC**: The aws_vpc resource creates the VPC with the specified CIDR block and enables DNS support.

- **Subnets**: The aws_subnet resources create the public and private subnets within the VPC. They assign the specified CIDR blocks, associate them with the VPC, and set other properties like availability zones and public IP mapping.

- **Internet Gateway**: The aws_internet_gateway resource creates an internet gateway and attaches it to the VPC.

- **Elastic IP**: The aws_eip resource allocates an Elastic IP address for the NAT gateway.

- **NAT Gateway**: The aws_nat_gateway resource creates a NAT gateway using the allocated Elastic IP and associates it with the public subnet.

- **Routing Tables**: The aws_route_table resources create the routing tables for the public and private subnets. They associate the tables with the VPC and set the appropriate routes.

- **Routes**: The aws_route resources define the routes for the internet and NAT gateways in the routing tables.

- **Route Table Associations**: The aws_route_table_association resources associate the subnets with their respective routing tables.

- **Variables**
The variables for this script are defined in the variables.tf file. You can modify these variables to customize the VPC infrastructure:

- **aws_region**: The AWS region where the VPC will be created.
- **vpc_cidr**: The CIDR block for the VPC.
- **public_subnets_cidr**: A list of CIDR blocks for the public subnets.
- **private_subnets_cidr**: A list of CIDR blocks for the private subnets.
- **environment**: The environment name or identifier for the resources.
