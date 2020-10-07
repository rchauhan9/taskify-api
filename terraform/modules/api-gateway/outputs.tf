output "rest_api_id" {
  value = aws_api_gateway_rest_api.api_gw_rest_api.id
}

output "resource_id" {
  value = aws_api_gateway_resource.api_gw_resource.id
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.api_gw_rest_api.execution_arn
}