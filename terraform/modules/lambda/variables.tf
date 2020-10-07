variable "function_name" {
  type = string
  description = "The name of the lambda function"
}

variable "filename" {
  type = string
  description = "The name of the zip file lambda should use."
}

variable "handler" {
  type = string
  description = "The name of the lambda handler"
}

variable "role" {
  type = string
  description = "The arn of the role the lambda should take on."
}