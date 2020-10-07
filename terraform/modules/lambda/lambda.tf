resource "aws_lambda_function" "taskify_lambda" {
  function_name = var.function_name
  filename = var.filename

  handler = var.handler
  runtime = "python3.6"

  role = var.role
}