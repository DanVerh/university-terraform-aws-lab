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

  attribute {
    name = "id"
    type = "S"
  }

  #provisioner "local-exec" {
    #command = "bash ./provisioners/dbdata.sh"
  #}
}
