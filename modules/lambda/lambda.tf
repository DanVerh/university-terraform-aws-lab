data "archive_file" "archive_function" {
  for_each = var.archive_functions

  type        = "zip"
  source_file = each.value.source_file
  output_path = each.value.output_path
}

resource "aws_lambda_function" "authors_parent" {  
  filename      = var.authors_parent.filename
  function_name = "${var.naming}-${var.authors_parent.function_name}"
  role          = var.role
  runtime       = "nodejs16.x"
  handler       = "index.handler"

  tags = {
    "method" = var.authors_parent["method"]
  }
}

resource "aws_lambda_function" "courses_parent" {
  for_each = var.courses_parent
  
  filename      = each.value.filename
  function_name = "${var.naming}-${each.value.function_name}"
  role          = var.role
  runtime       = "nodejs16.x"
  handler       = "index.handler"

  tags = {
    "method" = each.value.method
  }
}

resource "aws_lambda_function" "courses_child" {
  for_each = var.courses_child
  
  filename      = each.value.filename
  function_name = "${var.naming}-${each.value.function_name}"
  role          = var.role
  runtime       = "nodejs16.x"
  handler       = "index.handler"

  tags = {
    "method" = each.value.method
  }
}


