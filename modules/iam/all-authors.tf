#Create the role for get_all_authors lambda function
resource "aws_iam_role" "get_all_authors_lambda_role" {
  name = "get-all-authors-lambda-role"
  assume_role_policy = file("./policies/lambdaRole.json")
}

#Create a policy for Dynamo DB
resource "aws_iam_policy" "get_all_authors_dynamodb_policy" {
  name        = "get-all-authors-dynamodb-policy"
  policy      = templatefile("./policies/get-all-authors.tftpl", { authors = var.authors })
  #templatefile is used here to dynamically create a policy for required table that we need to take arn from
}

#Assign created policy to Lambda role
resource "aws_iam_role_policy_attachment" "get_all_authors_dynamodb_policy_attachment" {
  policy_arn = aws_iam_policy.get_all_authors_dynamodb_policy.arn
  role       = aws_iam_role.get_all_authors_lambda_role.name
}
