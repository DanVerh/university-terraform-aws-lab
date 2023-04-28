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

module "api-gateway" {
  source = "./modules/api-gateway"
  authors_parent = module.lambda.authors_parent
  #courses_parent = module.lambda.courses_parent
  #courses_child = module.lambda.courses_child
}