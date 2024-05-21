# Configure the AWS provider with the specified region
provider "aws" {
  region = var.aws_region
}

# Define an AWS Lambda function
resource "aws_lambda_function" "example_lambda" {
  filename         = "lambda_function.zip"  # The filename of the Lambda function code
  function_name    = "example-lambda"       # The name of the Lambda function
  role             = aws_iam_role.lambda_role.arn  # The ARN of the IAM role for the Lambda function
  handler          = "lambda_function.handler"    # The handler function within the Lambda function code
  runtime          = "python3.8"                   # The runtime environment for the Lambda function
  source_code_hash = filebase64sha256("lambda_function.zip")  # The hash of the Lambda function code
}

# Define an AWS IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"  # The name of the IAM role

  assume_role_policy = jsonencode({  # The policy that specifies which entity can assume the role
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Define an AWS API Gateway REST API
resource "aws_api_gateway_rest_api" "example_api" {
  name        = "example-api"                     # The name of the API Gateway REST API
  description = "Example API created with Terraform"  # A description for the API
}

# Define a resource within the API Gateway
resource "aws_api_gateway_resource" "example_resource" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id      # The ID of the API Gateway REST API
  parent_id   = aws_api_gateway_rest_api.example_api.root_resource_id  # The ID of the root resource
  path_part   = "mock"          # The path part of the resource URL
}

# Define a method for the API Gateway resource
resource "aws_api_gateway_method" "example_method" {
  rest_api_id   = aws_api_gateway_rest_api.example_api.id       # The ID of the API Gateway REST API
  resource_id   = aws_api_gateway_resource.example_resource.id  # The ID of the resource
  http_method   = "GET"         # The HTTP method for the method
  authorization = "NONE"        # The authorization type for the method
}

# Set up the integration between the API Gateway and the Lambda function
resource "aws_api_gateway_integration" "example_integration" {
  rest_api_id             = aws_api_gateway_rest_api.example_api.id       # The ID of the API Gateway REST API
  resource_id             = aws_api_gateway_resource.example_resource.id  # The ID of the resource
  http_method             = aws_api_gateway_method.example_method.http_method  # The HTTP method of the method
  integration_http_method = "POST"        # The HTTP method for the integration request
  type                    = "AWS_PROXY"   # The integration type
  uri                     = aws_lambda_function.example_lambda.invoke_arn  # The ARN of the Lambda function
}

# Define the method response for the API Gateway method
resource "aws_api_gateway_method_response" "example_method_response" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id       # The ID of the API Gateway REST API
  resource_id = aws_api_gateway_resource.example_resource.id  # The ID of the resource
  http_method = aws_api_gateway_method.example_method.http_method  # The HTTP method of the method
  status_code = "200"             # The status code for the method response

  response_parameters = {
    "method.response.header.Content-Type" = true  # The response header parameter for the method response
  }
}

# Define the integration response for the API Gateway integration
resource "aws_api_gateway_integration_response" "example_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id       # The ID of the API Gateway REST API
  resource_id = aws_api_gateway_resource.example_resource.id  # The ID of the resource
  http_method = aws_api_gateway_method.example_method.http_method  # The HTTP method of the method
  status_code = "200"             # The status code for the integration response

  response_parameters = {
    "method.response.header.Content-Type" = "'application/json'"  # The response header parameter for the integration response
  }

  response_templates = {
    "application/json" = jsonencode({  # The response template for the content type
      message = "Lambda response from Terraform-created API"
    })
  }
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "example_deployment" {
  depends_on = [
    aws_api_gateway_integration.example_integration_response,
    aws_api_gateway_method_response.example_method_response
  ]

  rest_api_id = aws_api_gateway_rest_api.example_api.id  # The ID of the API Gateway REST API
  stage_name  = "dev"           # The name of the deployment stage
}
