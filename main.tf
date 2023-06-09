module "naming" {
  source   = "cloudposse/label/null"

  namespace  = "edu"
  stage      = "prod"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "iam" {
  source = "./modules/iam"

  naming = module.naming.id
  authors = module.dynamodb.authors_arn
  courses = module.dynamodb.courses_arn

  depends_on = [ module.dynamodb ]
}

module "lambda" {
  source = "./modules/lambda"

  naming = module.naming.id
  role = module.iam.role_arn

  depends_on = [ module.iam ]
}

module "api-gateway" {
  source = "./modules/api-gateway"
  
  naming = module.naming.id
  authors_parent = module.lambda.authors_parent
  courses_parent = module.lambda.courses_parent
  courses_child = module.lambda.courses_child

  depends_on = [ module.lambda ]
}

module "s3" {
  source = "./modules/s3"

  naming = module.naming.id
  bucket_name = var.site_bucket_name
  api_url = module.api-gateway.api_url

  depends_on = [ module.api-gateway ]
}

module "monitoring" {
  source = "./modules/monitoring"

  naming = module.naming.id
  email = var.email
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