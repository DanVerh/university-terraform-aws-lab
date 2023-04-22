output "authors_arn" {
  value = aws_dynamodb_table.authors.arn
}

output "courses_arn" {
  value = aws_dynamodb_table.courses.arn
}