resource "aws_dynamodb_table" "table" {
  name           = var.table_name
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  range_key      = "username"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "username"
    type = "S"
  }

  global_secondary_index {
    name               = "username"
    hash_key           = "username"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

}