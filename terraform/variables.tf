variable "lambdas" {
  type = map(object({
    function_name = string
    filename = string
    handler = string
    http_method = string
  }))
  default = {
    "create": {
      function_name = "taskify-create-item"
      filename = "../create-item.zip"
      handler = "create-item.lambda_handler"
      http_method = "POST"
    },
    "delete": {
      function_name = "taskify-delete-item"
      filename = "../delete-item.zip"
      handler = "delete-item.lambda_handler"
      http_method = "DELETE"
    },
    "edit": {
      function_name = "taskify-edit-item"
      filename = "../edit-item.zip"
      handler = "edit-item.lambda_handler"
      http_method = "PATCH"
    },
    "get_all": {
      function_name = "taskify-get-all-items"
      filename = "../get-all-items.zip"
      handler = "get-all-items.lambda_handler"
      http_method = "GET"
    }
  }
}