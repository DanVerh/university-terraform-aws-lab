data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "error" {  
  filename      = var.error_function.filename
  function_name = var.error_function.function_name
  role          = var.role_arn
  runtime       = "python3.7"
  handler       = "index.lambda_handler"

  environment {
    variables = {
      snsARN = aws_sns_topic.alarms.arn
    }
  }
}

resource "aws_iam_policy" "error_policy" {
  name        = "error-policy"
  policy      = templatefile("./policies/error-policy.tftpl", { sns_topic_arn = aws_sns_topic.alarms.arn, region = "us-east-1", account_number = data.aws_caller_identity.current.account_id, function_name = var.error_function.function_name })
}

resource "aws_iam_role_policy_attachment" "error_policy_attachment" {
  policy_arn = aws_iam_policy.error_policy.arn
  role       = var.role_name
}

