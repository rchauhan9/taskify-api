resource "aws_api_gateway_rest_api" "api_gw_rest_api" {
  name = var.rest_api_name
}

resource "aws_api_gateway_resource" "api_gw_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gw_rest_api.id
  parent_id   = aws_api_gateway_rest_api.api_gw_rest_api.root_resource_id
  path_part   = var.path_part
}