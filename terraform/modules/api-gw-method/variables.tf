variable "api_gw_rest_id" {
  type = string
  description = "The ID of the API Gateway rest api resource"
}

variable "api_gw_resource_id" {
  type = string
  description = "The ID of the API Gateway resource resource"
}

variable "http_method" {
  type = string
  description = "The HTTP method to invoke."
}

variable "uri" {
  type = string
  description = "The URI endpoint to invoke"
}