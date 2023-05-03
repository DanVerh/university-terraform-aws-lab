# REST API Gateway
resource "aws_api_gateway_rest_api" "courses_api" {
  name                 = "courses-api"
  endpoint_configuration {
    types = ["EDGE"]
  }
}

# Resources
resource "aws_api_gateway_resource" "authors_parent" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  parent_id   = aws_api_gateway_rest_api.courses_api.root_resource_id
  path_part   = "authors"
}

# Permissions
resource "aws_lambda_permission" "authors_parent" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.authors_parent["name"]
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.courses_api.execution_arn}/*/*"
}

# Method
resource "aws_api_gateway_method" "authors_parent" {
  rest_api_id   = aws_api_gateway_rest_api.courses_api.id
  resource_id   = aws_api_gateway_resource.authors_parent.id
  http_method   = var.authors_parent["method"]
  authorization = "NONE"
  api_key_required = false
}

# Integration
resource "aws_api_gateway_integration" "authors_parent" {
  rest_api_id             = aws_api_gateway_rest_api.courses_api.id
  resource_id             = aws_api_gateway_resource.authors_parent.id
  http_method             = var.authors_parent["method"]
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = var.authors_parent["arn"]

  depends_on = [ aws_api_gateway_method.authors_parent ]
}

# Deployment
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  stage_name  = "prod"

  depends_on = [ aws_api_gateway_method.authors_parent, aws_api_gateway_integration.authors_parent ]
}

# Response
resource "aws_api_gateway_method_response" "authors_parent" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.authors_parent.id
  http_method = var.authors_parent["method"]
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [ aws_api_gateway_deployment.deployment ]
}

# Integration Response
resource "aws_api_gateway_integration_response" "example" {
  rest_api_id =  aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.authors_parent.id
  http_method = var.authors_parent["method"]
  status_code = aws_api_gateway_method_response.authors_parent.status_code

  depends_on = [ aws_api_gateway_deployment.deployment ]
}
