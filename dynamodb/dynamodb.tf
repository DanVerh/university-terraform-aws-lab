resource "aws_dynamodb_table" "courses" {
  name         = "courses"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "authors" {
  name         = "authors"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  dynamic "attribute" {
    for_each = ["id", "firstName", "lastName"]
    content {
      name = attribute.value
      type = "S"
    }
  }

  global_secondary_index {
    name               = "index"
    hash_key           = "lastName"
    range_key          = "firstName"
    projection_type    = "KEYS_ONLY"
    non_key_attributes = ["address"]
  }

}
