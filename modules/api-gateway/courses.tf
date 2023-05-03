# Resources
resource "aws_api_gateway_resource" "courses_parent" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  parent_id   = aws_api_gateway_rest_api.courses_api.root_resource_id
  path_part   = "courses"
}

# Permissions
resource "aws_lambda_permission" "courses_parent" {
  for_each = var.courses_parent

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = each.value.name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.courses_api.execution_arn}/*/*"
}

# Integration
resource "aws_api_gateway_integration" "courses_parent" {
  for_each = var.courses_parent

  rest_api_id             = aws_api_gateway_rest_api.courses_api.id
  resource_id             = aws_api_gateway_resource.courses_parent.id
  http_method             = each.value.method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = each.value.arn

  depends_on = [ aws_api_gateway_method.courses_parent ]
}

# Method
resource "aws_api_gateway_method" "courses_parent" {
  for_each = var.courses_parent

  rest_api_id   = aws_api_gateway_rest_api.courses_api.id
  resource_id   = aws_api_gateway_resource.courses_parent.id
  http_method   = each.value.method
  authorization = "NONE"
  api_key_required = false
}

# Response
resource "aws_api_gateway_method_response" "courses_parent" {
  for_each = var.courses_parent

  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.courses_parent.id
  http_method = each.value.method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true
    }

  depends_on = [ aws_api_gateway_deployment.deployment ]
}

# Integration Response
resource "aws_api_gateway_integration_response" "courses_parent" {
  for_each = var.courses_parent

  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.courses_parent.id
  http_method = each.value.method
  status_code = aws_api_gateway_method_response.courses_parent[each.key].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
   }

  depends_on = [ aws_api_gateway_deployment.deployment ]
}
