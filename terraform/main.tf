provider "aws" {
  region = "eu-west-2"
}

module "dynamo_db" {
  source = "./modules/dynamodb"
  table_name = "Taskify"
}

module "lambda_execution_role" {
  source = "./modules/lambda-execution-iam"
}

module "taskify_lambda" {
  source = "./modules/lambda"
  for_each = var.lambdas

  function_name = each.value.function_name
  filename = each.value.filename
  handler = each.value.handler
  role = module.lambda_execution_role.iam_role_arn
}

module "taskify_api_gw" {
  source = "./modules/api-gateway"
  rest_api_name = "taskify-api"
  path_part = "tasks"
}

module "api_gw_method" {
  source = "./modules/api-gw-method"
  for_each = var.lambdas

  api_gw_rest_id = module.taskify_api_gw.rest_api_id
  api_gw_resource_id = module.taskify_api_gw.resource_id
  http_method = each.value.http_method
  uri = module.taskify_lambda[each.key].invoke_arn
}

resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    module.api_gw_method[0].api_gw_integration,
    module.api_gw_method[1].api_gw_integration,
    module.api_gw_method[2].api_gw_integration,
    module.api_gw_method[3].api_gw_integration
  ]

  rest_api_id = module.taskify_api_gw.rest_api_id
  stage_name = "dev"
}

module "apigw_lambda_permissions" {
  source = "./modules/lambda-api-gw-trigger"
  for_each = var.lambdas
  function_name = module.taskify_lambda[each.key].function_name
  source_arn = module.taskify_api_gw.execution_arn
}