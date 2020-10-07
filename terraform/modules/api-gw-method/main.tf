resource "aws_api_gateway_method" "api_gw_method" {
  rest_api_id = var.api_gw_rest_id
  resource_id = var.api_gw_resource_id
  http_method = var.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_gw_integration" {
  rest_api_id = var.api_gw_rest_id
  resource_id = var.api_gw_resource_id
  http_method = aws_api_gateway_method.api_gw_method.http_method

  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = var.uri
  content_handling = "CONVERT_TO_TEXT"
}