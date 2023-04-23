#Create the role for get_all_authors lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"
  assume_role_policy = file("./policies/lambdaRole.json")
}

resource "aws_iam_policy" "authors_policy" {
  name        = "get-all-authors-policy"
  policy      = templatefile("./policies/get-all-authors-policy.tftpl", { authors = var.authors })
  #templatefile is used here to dynamically create a policy for required table that we need to take arn from
}

resource "aws_iam_role_policy_attachment" "authors_policy_attachment" {
  policy_arn = aws_iam_policy.authors_policy.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_policy" "courses_policy" {
  for_each = var.policies

  name        = each.value.name
  policy      = templatefile("${each.value.path}", { courses = var.courses })
  #templatefile is used here to dynamically create a policy for required table that we need to take arn from
}
