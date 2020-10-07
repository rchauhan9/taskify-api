variable "function_name" {
  type = string
  description = "The name of the lambda function to invoke"
}

variable "source_arn" {
  type = string
  description = "The arn of the source that triggers invocation"
}