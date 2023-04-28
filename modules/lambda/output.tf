output "authors_parent" {
  value = {
    name = aws_lambda_function.authors_parent.function_name
    arn = aws_lambda_function.authors_parent.invoke_arn
    method = aws_lambda_function.authors_parent.tags.method
  }
}

output "courses_parent" {
  value = {
    for function in aws_lambda_function.courses_parent : function.function_name => {
      name = function.function_name
      arn = function.invoke_arn
      method = function.tags.method
    }
  }
}

output "courses_child" {
  value = {
    for function in aws_lambda_function.courses_child : function.function_name => {
      name = function.function_name
      arn = function.invoke_arn
      method = function.tags.method
    }
  }
}