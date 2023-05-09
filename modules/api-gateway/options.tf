# FOR PARENT RESOURCE

# Integration
resource "aws_api_gateway_integration" "options" {
  for_each = var.courses_parent

  rest_api_id             = aws_api_gateway_rest_api.courses_api.id
  resource_id             = aws_api_gateway_resource.courses_parent.id
  http_method             = "OPTIONS"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = each.value.arn

  depends_on = [ aws_api_gateway_method.courses_parent ]
}

# Method
resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.courses_api.id
  resource_id   = aws_api_gateway_resource.courses_parent.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  api_key_required = false
}

# Response
resource "aws_api_gateway_method_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.courses_parent.id
  http_method = "OPTIONS"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true,
        "method.response.header.Access-Control-Expose-Headers" = true
    }

  depends_on = [ aws_api_gateway_deployment.deployment ]
}

# Integration Response
resource "aws_api_gateway_integration_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.courses_parent.id
  http_method = "OPTIONS"
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Expose-Headers" = "'*'"
   }

  depends_on = [ aws_api_gateway_deployment.deployment, aws_api_gateway_method_response.options ]
}


# FOR CHILD RESOURCE

# Integration
resource "aws_api_gateway_integration" "options_child" {
  for_each = var.courses_child

  rest_api_id             = aws_api_gateway_rest_api.courses_api.id
  resource_id             = aws_api_gateway_resource.courses_child.id
  http_method             = "OPTIONS"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = each.value.arn

  depends_on = [ aws_api_gateway_method.courses_child ]
}

# Method
resource "aws_api_gateway_method" "options_child" {
  rest_api_id   = aws_api_gateway_rest_api.courses_api.id
  resource_id   = aws_api_gateway_resource.courses_child.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  api_key_required = false
}

# Response
resource "aws_api_gateway_method_response" "options_child" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.courses_child.id
  http_method = "OPTIONS"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true,
        "method.response.header.Access-Control-Expose-Headers" = true
    }

  depends_on = [ aws_api_gateway_deployment.deployment ]
}

# Integration Response
resource "aws_api_gateway_integration_response" "options_child" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.courses_child.id
  http_method = "OPTIONS"
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Expose-Headers" = "'*'"
   }

  depends_on = [ aws_api_gateway_deployment.deployment, aws_api_gateway_method_response.options_child ]
}

