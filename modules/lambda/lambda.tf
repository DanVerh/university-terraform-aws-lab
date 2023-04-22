data "archive_file" "get_all_authors" {
  type        = "zip"
  source_file = "./functions/get-all-authors/index.js"
  output_path = "./functions/get-all-authors.zip"
}

resource "aws_lambda_function" "get_all_authors" {
  filename      = "./functions/get-all-authors.zip"
  function_name = "get-all-authors"
  role          = var.role
  runtime       = "nodejs12.x"
  handler = "index.handler"
}

