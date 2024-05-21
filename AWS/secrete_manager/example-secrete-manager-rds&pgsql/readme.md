# Terraform AWS RDS Cluster Setup

This Terraform script deploys an AWS RDS cluster with associated resources such as VPC, subnets, and a DB subnet group.

## Prerequisites

Before running this Terraform script, make sure you have the following:

- Terraform installed on your local machine.
- AWS credentials with appropriate permissions.
- AWS CLI configured with the desired AWS region.

## Usage

1. Clone this repository to your local machine:
```
git clone <repository_url>
```

Navigate to the cloned repository:
```
cd terraform-aws-rds-cluster
```

Initialize the Terraform working directory:
```
terraform init
```
Customize the variables:

Open the **variables.tf** file and modify the variables according to your requirements. You can specify the AWS region (region), VPC CIDR block (vpc_cidr), subnet CIDR blocks (subnet_cidr_1 and subnet_cidr_2), DB subnet group name (db_subnet_group_name), RDS cluster identifier (cluster_identifier), database name (database_name), and instance count (instance_count). open **terraform.tfvars** file to override varaible inputs. 

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

- AWS provider: Configures the AWS access credentials and specifies the desired region.
- Random password: Generates a random password of length 16 with special characters and assigns it to the `random_password.password.result` output.
- VPC: Creates an AWS VPC with the specified CIDR block (`var.vpc_cidr`).
- Subnets: Creates two AWS subnets (`subnet_1` and `subnet_2`) within the VPC. Each subnet is associated with a specific CIDR block (`var.subnet_cidr_1` and `var.subnet_cidr_2`).
- DB subnet group: Creates an AWS DB subnet group with the specified name (`var.db_subnet_group_name`) and adds the created subnets to the group.
- RDS cluster: Creates an AWS RDS cluster with the specified cluster identifier (`var.cluster_identifier`), database name (`var.database_name`), master username (`random_password.password.result`), master password (`random_password.password.result`), port (`5432`), engine (`aurora-postgresql`), engine version (`14`), DB subnet group name (`aws_db_subnet_group.db_subnet_group.name`), and storage encryption enabled.
- RDS cluster instances: Creates AWS RDS cluster instances based on the specified instance count (`var.instance_count`). Each instance is associated with the RDS cluster, has a unique identifier, and is publicly accessible.

Destroy the resources:

If you want to tear down the created resources, run the following command:
```
terraform destroy
```

This will remove all the resources created by Terraform.

## Configuration

The main configuration file for this script is main.tf. It defines the AWS provider and declares the AWS resources to be created.

- Provider: The AWS provider block configures the AWS access credentials and specifies the desired region.

- Random Password: The random_password resource generates a random password of length 16 with special characters and assigns it to the random_password.password.result output.

- VPC: The aws_vpc resource creates an AWS VPC with the specified CIDR block (var.vpc_cidr).

- Subnets: The aws_subnet resources create AWS subnets within the VPC. Each subnet is associated with the VPC and has a specific CIDR block (var.subnet_cidr_1 and var.subnet_cidr_2).

- DB Subnet Group: The aws_db_subnet_group resource creates an AWS DB subnet group with the specified name (var.db_subnet_group_name) and associates the created subnets (aws_subnet.subnet_1.id and aws_subnet.subnet_2.id) with the group.
