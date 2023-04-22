module "dynamodb" {
  source = "./modules/dynamodb"
}

module "iam" {
  source = "./modules/iam"
  authors = module.dynamodb.authors_arn
  courses = module.dynamodb.courses_arn
}

module "lambda" {
  source = "./modules/lambda"
  role = module.iam.role_arn
}