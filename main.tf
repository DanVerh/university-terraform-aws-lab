module "dynamodb" {
  source = "./modules/dynamodb"
}

module "iam" {
  source = "./modules/iam"
  authors = module.dynamodb.authors_arn
}