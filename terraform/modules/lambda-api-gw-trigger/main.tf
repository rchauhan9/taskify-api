resource "aws_lambda_permission" "apigw-create" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = var.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${var.source_arn}/*/*"
}