output "cloudfront_url" {
  value = aws_cloudfront_distribution.web_app.domain_name
}