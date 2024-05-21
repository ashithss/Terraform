# Terraform AWS SQS Queue Setup

This Terraform script creates an AWS Simple Queue Service (SQS) queue and configures a dead-letter queue, IAM policy, role, and policy attachment for the queue.

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
1. Navigate to the cloned repository:

```
cd terraform-aws-sqs
```

1. Initialize the Terraform working directory:

```
terraform init
```

1. Customize the variables:

Open the `variables.tf` file and modify the variables according to your requirements. You can specify the queue name, enable/disable the dead-letter queue, and configure additional policies and statements if needed.

1. Review the execution plan:

Run the following command to see the execution plan:

```
terraform plan
```

This will show you the changes that Terraform will apply to your AWS infrastructure.

1. Deploy the resources:

If the execution plan looks good, apply the changes:

```
terraform apply
```

Terraform will create the following AWS resources:

- SQS queue: The main SQS queue with the specified name (`var.queue_name`).
- Dead-letter queue (optional): A separate queue for handling failed messages, configured if `var.enable_dead_letter_queue` is set to `true`.
- IAM policy: An IAM policy that allows necessary actions on the SQS queue.
- IAM role: An IAM role that is assumed by the SQS service and attached to the IAM policy.
- IAM policy attachment: Associates the IAM policy with the IAM role.

1. Destroy the resources:

If you want to tear down the created resources, run the following command:

```
terraform destroy
```

This will remove all the resources created by Terraform.

## Configuration

The main configuration file for this script is `main.tf`. It defines the AWS provider and declares the AWS resources to be created.

- **Provider**: The AWS provider block configures the AWS access credentials and specifies the desired region.

- **SQS Queue**: The `aws_sqs_queue` resource creates the main SQS queue with the specified name (`var.queue_name`).

- **Dead-Letter Queue**: The `aws_sqs_queue` resource creates a secondary queue for handling failed messages, if enabled.

- **IAM Policy**: The `aws_iam_policy` resource defines the IAM policy that allows necessary actions on the SQS queue.

- **IAM Role**: The `aws_iam_role` resource creates an IAM role that is assumed by the SQS service.

- **IAM Policy Attachment**: The `aws_iam_role_policy_attachment` resource associates the IAM policy with the IAM role.

## Variables

The variables for this script are defined in the `variables.tf` file. You can modify these variables to customize the SQS queue setup:

- `queue_name`: The name of the main SQS queue.
- `enable_dead_letter_queue`: Set to `true` to enable the dead-letter queue configuration.
- Additional variables for customizing policies and statements are also available.
