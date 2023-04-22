data "archive_file" "archive_function" {
  for_each = var.archive_functions

  type        = "zip"
  source_file = each.value.source_file
  output_path = each.value.output_path
}

resource "aws_lambda_function" "function" {
  for_each = var.functions
  
  filename      = each.value.filename
  function_name = each.value.function_name
  role          = var.role
  runtime       = "nodejs12.x"
  handler       = "index.handler"
}

