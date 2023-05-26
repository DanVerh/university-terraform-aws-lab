module "dynamodb" {
  source = "./modules/dynamodb"
}

module "iam" {
  source = "./modules/iam"
  authors = module.dynamodb.authors_arn
  courses = module.dynamodb.courses_arn

  depends_on = [ module.dynamodb ]
}

module "lambda" {
  source = "./modules/lambda"
  role = module.iam.role_arn

  depends_on = [ module.iam ]
}

module "api-gateway" {
  source = "./modules/api-gateway"
  authors_parent = module.lambda.authors_parent
  courses_parent = module.lambda.courses_parent
  courses_child = module.lambda.courses_child
  depends_on = [ module.lambda ]
}

module "s3" {
  source = "./modules/s3"
  api_url = module.api-gateway.api_url

  depends_on = [ module.api-gateway ]
}

module "monitoring" {
  source = "./modules/monitoring"
  role_arn = module.iam.role_arn
  role_name = module.iam.role_name
  authors_parent = module.lambda.authors_parent
  courses_parent = module.lambda.courses_parent
  courses_child = module.lambda.courses_child

  depends_on = [ module.lambda ]
}

output "website_url" {
  value = module.s3.cloudfront_url
}