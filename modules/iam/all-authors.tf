resource "aws_iam_role" "get_all_authors_lambda_role" {
  name = "get-all-authors-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "get_all_authors_dynamodb_policy" {
  name        = "get-all-authors-dynamodb-policy"
  policy      = templatefile("./policies/get-all-authors.tftpl", {authors = var.authors })
}

resource "aws_iam_role_policy_attachment" "get_all_authors_dynamodb_policy_attachment" {
  policy_arn = aws_iam_policy.get_all_authors_dynamodb_policy.arn
  role       = aws_iam_role.get_all_authors_lambda_role.name
}
