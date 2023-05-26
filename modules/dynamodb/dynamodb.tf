#Table for courses
resource "aws_dynamodb_table" "courses" {
  name         = "courses"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

#We need to mention only one attribute that is a hash_key, because it is unstructured DB
  attribute {
    name = "id"
    type = "S"
  }
}

#Table for authors
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
