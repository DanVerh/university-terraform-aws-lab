#Create the role for get_all_authors lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"
  assume_role_policy = file("./policies/lambdaRole.json")
}


#Create a policy for authors table
resource "aws_iam_policy" "get_authors_policy" {
  name        = "get-authors-policy"
  policy      = templatefile("./policies/authorsPolicy.tftpl", { authors = var.authors })
  #templatefile is used here to dynamically create a policy for required table that we need to take arn from
}

#Assign created policy to Lambda role
resource "aws_iam_role_policy_attachment" "get_authors_policy_attachment" {
  policy_arn = aws_iam_policy.get_authors_policy.arn
  role       = aws_iam_role.lambda_role.name
}


#Create a policy for courses table
resource "aws_iam_policy" "put-courses-policy" {
  name        = "put-courses-policy"
  policy      = templatefile("./policies/coursesPolicy.tftpl", { courses = var.courses })
  #templatefile is used here to dynamically create a policy for required table that we need to take arn from
}

#Assign created policy to Lambda role
resource "aws_iam_role_policy_attachment" "put-courses-policy_attachment" {
  policy_arn = aws_iam_policy.put-courses-policy.arn
  role       = aws_iam_role.lambda_role.name
}


