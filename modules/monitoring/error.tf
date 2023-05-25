data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "authors" {
  name              = "/aws/lambda/${var.authors_parent["name"]}"
  retention_in_days = 90
}


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
  #policy      = templatefile("./policies/error-policy.tftpl", { sns_topic_arn = aws_sns_topic.alarms.arn, region = "us-east-1", account_number = data.aws_caller_identity.current.account_id, function_name = var.error_function.function_name, function_arn = aws_lambda_function.error.arn })
  policy      = templatefile("./policies/error-policy.tftpl", { sns_topic_arn = aws_sns_topic.alarms.arn, function_arn = aws_lambda_function.error.arn })
}

resource "aws_iam_role_policy_attachment" "error_policy_attachment" {
  policy_arn = aws_iam_policy.error_policy.arn
  role       = var.role_name
}

resource "aws_lambda_permission" "authors" {
  statement_id  = "authors-permission"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.error.arn
  principal     = "logs.us-east-1.amazonaws.com"
  source_arn = "${aws_cloudwatch_log_group.authors.arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "authors_error" {
  name            = "authors-subscription-filter"
  log_group_name  = "/aws/lambda/${var.authors_parent["name"]}"
  filter_pattern  = "?ERROR ?WARN ?5xx"
  destination_arn = aws_lambda_function.error.arn

  depends_on = [ aws_lambda_permission.authors ]
}


#resource "aws_cloudwatch_log_subscription_filter" "courses_parent_error" {
  #for_each = var.courses_parent
#
  #name            = "courses-parent-subscription-filter"
  #log_group_name  = "/aws/lambda/${each.value.name}"
  #filter_pattern  = "?ERROR ?WARN ?5xx"
  #destination_arn = aws_lambda_function.error.arn
#}
#
#resource "aws_lambda_permission" "courses_parent" {
  #for_each = var.courses_parent
#
  #statement_id  = "courses-parent-permission"
  #action        = "lambda:InvokeFunction"
  #function_name = each.value.name
  #principal     = "logs.amazonaws.com"
  #source_arn    = aws_cloudwatch_log_subscription_filter.courses_parent_error.role_arn
#}
#
#resource "aws_cloudwatch_log_subscription_filter" "courses_child_error" {
  #for_each = var.courses_child
#
  #name            = "courses-child-subscription-filter"
  #log_group_name  = "/aws/lambda/${each.value.name}"
  #filter_pattern  = "?ERROR ?WARN ?5xx"
  #destination_arn = aws_lambda_function.error.arn
#}
#
#resource "aws_lambda_permission" "courses_child" {
  #for_each = var.courses_child
#
  #statement_id  = "courses-child-permission"
  #action        = "lambda:InvokeFunction"
  #function_name = each.value.name
  #principal     = "logs.amazonaws.com"
  #source_arn    = aws_cloudwatch_log_subscription_filter.courses_child_error.role_arn
#}