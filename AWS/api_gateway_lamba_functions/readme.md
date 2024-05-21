This repository contains Terraform code to create an AWS Lambda function and an API Gateway with integration to the Lambda function. The infrastructure is defined as code using the Terraform configuration language.

# Prerequisites
Before you can use this Terraform configuration, make sure you have the following prerequisites:

- Terraform ↗ installed on your local machine.

- AWS account credentials configured on your machine, either through environment variables or the AWS CLI.

# Getting Started

To use this Terraform configuration, follow these steps:

Clone this repository to your local machine.

```
git clone <repository-url>
```

Change into the cloned directory.

```
cd <repository-directory>
```

Initialize the Terraform working directory.

```
terraform init
```

Customize the configuration.

Open the main.tf file and modify any desired variables. For example, you may want to change the AWS region or the function name.

Validate the format and syntax:

```
terraform validate
```
If everything is validated proceed for planning

Review the execution plan.

```
terraform plan
```

This will show you the actions that Terraform will take when applying the configuration.

Apply the configuration.

```
terraform apply
```

This will create the AWS Lambda function and API Gateway.

Test the API using **.zip** file provided.

Once the Terraform apply is successful, you can test the API by sending a GET request to the provided endpoint.

Clean up.

To clean up and destroy the created resources, run:

```
terraform destroy
```

This will remove all the resources created by Terraform.

## Configuration

The Terraform configuration consists of the following files:

- **main.tf**: Defines the AWS provider and the resources to be created, including the Lambda function, IAM role, API Gateway, and associated resources.
- **variables.tf**: Declares the input variables used in the configuration.
- **outputs.tf**: Defines the output values that will be displayed after applying the configuration.
- **terraform.tfvars**: Use this to override the inputs in variables.tf

## Overview

The provided Terraform code is used to create infrastructure resources on AWS. It sets up an AWS Lambda function and an API Gateway with integration to the Lambda function. 
Here's a breakdown of what each resource does:

**AWS Provider**
The code starts by configuring the AWS provider and specifying the region where the resources will be created.

**AWS Lambda Function**
The aws_lambda_function resource defines an AWS Lambda function. It specifies the function's properties, such as the filename of the Lambda function code (lambda_function.zip), the function name (example-lambda), the IAM role (aws_iam_role.lambda_role) that grants permissions to the Lambda function, the handler function (lambda_function.handler), the runtime (python3.8), and the source code hash.

**AWS IAM Role**
The aws_iam_role resource creates an IAM role that allows the Lambda function to assume a role with the specified policies. In this case, the role is named lambda-role, and the assume_role_policy specifies that the Lambda service (lambda.amazonaws.com) is allowed to assume this role.

**AWS API Gateway**
The aws_api_gateway_rest_api resource creates an API Gateway REST API. It defines the name and description of the API.

**API Gateway Resource**
The aws_api_gateway_resource resource creates a resource within the API Gateway. It specifies that the resource is a child of the API Gateway REST API created earlier and sets the path of the resource to mock.

**API Gateway Method**
The aws_api_gateway_method resource defines a method for the API Gateway resource. It specifies that the method is a GET method and has no authorization requirements.

**API Gateway Integration**
The aws_api_gateway_integration resource sets up the integration between the API Gateway and the Lambda function. It specifies that the integration is of type AWS_PROXY and sets the URI to the ARN of the Lambda function.

**API Gateway Method Response**
The aws_api_gateway_method_response resource defines the method response for the API Gateway method. It sets the status code to 200 and adds a response header parameter Content-Type to the method response.

**API Gateway Integration Response**
The aws_api_gateway_integration_response resource defines the integration response for the API Gateway integration. It sets the status code to 200, adds a response header parameter Content-Type to the integration response, and specifies a response template for the application/json content type.

**API Gateway Deployment**
The aws_api_gateway_deployment resource deploys the API Gateway. It depends on the completion of the integration response and method response resources. It sets the stage name to dev.
