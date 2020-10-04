//module "iam" {
//  source = "./iam"
//}
//
//module "lambda" {
//  source = "./lambda"
//  iam-role = module.iam.iam_role_arn
//}
//
//module "dynamodb" {
//  source = "./dynamodb"
//}

provider "aws" {
   region = "eu-west-2"
}

resource "aws_dynamodb_table" "Taskify" {
  name           = "Taskify"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  range_key      = "username"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "username"
    type = "S"
  }

  global_secondary_index {
    name               = "username"
    hash_key           = "username"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda-basic-execution"
  description = "Allows Lambda functions to call AWS services on your behalf."
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "aws_lambda_basic_execution_role" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "aws_dynamo_db_full_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_lambda_function" "taskify-create-item" {
  function_name = "taskify-create-item"
  filename = "../create-item.zip"

  handler = "create-item.lambda_handler"
  runtime = "python3.6"

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "taskify-delete-item" {
  function_name = "taskify-delete-item"
  filename = "../delete-item.zip"

  handler = "delete-item.lambda_handler"
  runtime = "python3.6"

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "taskify-edit-item" {
  function_name = "taskify-edit-item"
  filename = "../edit-item.zip"

  handler = "edit-item.lambda_handler"
  runtime = "python3.6"

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "taskify-get-all-items" {
  function_name = "taskify-get-all-items"
  filename = "../get-all-items.zip"

  handler = "get-all-items.lambda_handler"
  runtime = "python3.6"

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_api_gateway_rest_api" "taskify-api" {
  name = "taskify-api"
}

resource "aws_api_gateway_resource" "tasks" {
  rest_api_id = aws_api_gateway_rest_api.taskify-api.id
  parent_id   = aws_api_gateway_rest_api.taskify-api.root_resource_id
  path_part   = "tasks"
}

resource "aws_api_gateway_method" "create" {
  rest_api_id   = aws_api_gateway_rest_api.taskify-api.id
  resource_id   = aws_api_gateway_resource.tasks.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "create" {
  rest_api_id = aws_api_gateway_rest_api.taskify-api.id
  resource_id = aws_api_gateway_method.create.resource_id
  http_method = aws_api_gateway_method.create.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.taskify-create-item.invoke_arn
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method" "delete" {
  rest_api_id   = aws_api_gateway_rest_api.taskify-api.id
  resource_id   = aws_api_gateway_resource.tasks.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "delete" {
  rest_api_id = aws_api_gateway_rest_api.taskify-api.id
  resource_id = aws_api_gateway_method.delete.resource_id
  http_method = aws_api_gateway_method.delete.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.taskify-delete-item.invoke_arn
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method" "edit" {
  rest_api_id   = aws_api_gateway_rest_api.taskify-api.id
  resource_id   = aws_api_gateway_resource.tasks.id
  http_method   = "PATCH"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "edit" {
  rest_api_id = aws_api_gateway_rest_api.taskify-api.id
  resource_id = aws_api_gateway_method.edit.resource_id
  http_method = aws_api_gateway_method.edit.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.taskify-edit-item.invoke_arn
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.taskify-api.id
  resource_id   = aws_api_gateway_resource.tasks.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get" {
  rest_api_id = aws_api_gateway_rest_api.taskify-api.id
  resource_id = aws_api_gateway_method.get.resource_id
  http_method = aws_api_gateway_method.get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.taskify-get-all-items.invoke_arn
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_deployment" "example" {
   depends_on = [
     aws_api_gateway_integration.create,
     aws_api_gateway_integration.delete,
     aws_api_gateway_integration.edit,
     aws_api_gateway_integration.get
   ]

   rest_api_id = aws_api_gateway_rest_api.taskify-api.id
   stage_name  = "dev"
}

resource "aws_lambda_permission" "apigw-create" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.taskify-create-item.function_name
   principal     = "apigateway.amazonaws.com"
   source_arn = "${aws_api_gateway_rest_api.taskify-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw-delete" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.taskify-delete-item.function_name
   principal     = "apigateway.amazonaws.com"
   source_arn = "${aws_api_gateway_rest_api.taskify-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw-edit" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.taskify-edit-item.function_name
   principal     = "apigateway.amazonaws.com"
   source_arn = "${aws_api_gateway_rest_api.taskify-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw-get-all" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.taskify-get-all-items.function_name
   principal     = "apigateway.amazonaws.com"
   source_arn = "${aws_api_gateway_rest_api.taskify-api.execution_arn}/*/*"
}
