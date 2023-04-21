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

#attribute {
   #name = "id"
   #type = "S"
 #}
#
 #attribute {
   #name = "firstName"
   #type = "S"
 #}
#
  #attribute {
   #name = "lastName"
   #type = "S"
 #}

 dynamic "attribute" {
   for_each = ["id", "firstName", "lastName"]
   content {
     name = attribute.value
     type = "S"
   }
 }
}
