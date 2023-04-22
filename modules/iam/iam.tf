#Create the role for get_all_authors lambda function
resource "aws_iam_role" "get_all_authors_role" {
  name = "get-all-authors-lambda-role"
  assume_role_policy = file("./policies/lambdaRole.json")
}

#Create a policy for Dynamo DB
resource "aws_iam_policy" "get_all_authors_policy" {
  name        = "get-all-authors-policy"
  policy      = templatefile("./policies/authorsPolicy.tftpl", { authors = var.authors })
  #templatefile is used here to dynamically create a policy for required table that we need to take arn from
}

#Assign created policy to Lambda role
resource "aws_iam_role_policy_attachment" "get_all_authors_policy_attachment" {
  policy_arn = aws_iam_policy.get_all_authors_policy.arn
  role       = aws_iam_role.get_all_authors_role.name
}
