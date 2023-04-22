data "archive_file" "get_all_authors" {
  for_each = var.archive_functions

  type        = "zip"
  source_file = each.value.source_file
  output_path = each.value.output_path
}

resource "aws_lambda_function" "get_all_authors" {
  filename      = "./functions/get-all-authors.zip"
  function_name = "get-all-authors"
  role          = var.role
  runtime       = "nodejs12.x"
  handler = "index.handler"
}

