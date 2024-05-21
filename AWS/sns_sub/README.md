SNS topic with mail and sms notification.

# Terraform AWS SNS Topic Setup

This Terraform script creates an AWS SNS (Simple Notification Service) topic and conditionally creates email and SMS subscriptions based on the `enable_subscribers` variable.

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
cd terraform-aws-sns
```

Initialize the Terraform working directory:

```
terraform init
```

Customize the variables:

Open the variables.tf file and modify the variables according to your requirements. You can specify the AWS region (aws_region), topic name (topic_name), enable/disable subscribers (enable_subscribers), and subscriber emails or phones (subscriber_emails, subscriber_phones).

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

- **SNS topic**: Creates an SNS topic with the specified name (`topic_name`).
- **Email subscriptions (conditionally)**: Creates email subscriptions if `enable_subscribers` is set to `true`. The email addresses are specified in the `subscriber_emails` variable.
- **SMS subscriptions (conditionally)**: Creates SMS subscriptions if `enable_subscribers` is set to `true`. The phone numbers are specified in the `subscriber_phones` variable.

Destroy the resources:

If you want to tear down the created resources, run the following command:
```
terraform destroy
```

This will remove all the resources created by Terraform.

## Configuration

The main configuration file for this script is main.tf. It defines the AWS provider and declares the AWS resources to be created.

Provider: The AWS provider block configures the AWS access credentials and specifies the desired region.

SNS Topic: The aws_sns_topic resource creates an SNS topic with the specified name (var.topic_name).

Email Subscriptions: The aws_sns_topic_subscription resource conditionally creates email subscriptions if var.enable_subscribers is set to true. The subscriptions are created based on the email addresses specified in the var.subscriber_emails variable.

SMS Subscriptions: The aws_sns_topic_subscription resource conditionally creates SMS subscriptions if var.enable_subscribers is set to true. The subscriptions are created based on the phone numbers specified in the var.subscriber_phones variable.

## Variables
The variables for this script are defined in the variables.tf file. You can modify these variables to customize the SNS topic setup:

- **aws_region** : The AWS region where the SNS topic will be created.
- **topic_name** : The name of the SNS topic.
- **enable_subscribers** : Set to true to enable the creation of subscribers.
- **subscriber_emails** : A list of email addresses for email subscriptions.
- **subscriber_phones** : A list of phone numbers for SMS subscriptions.
