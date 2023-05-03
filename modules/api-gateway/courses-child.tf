# Resources
resource "aws_api_gateway_resource" "courses_child" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  parent_id   = aws_api_gateway_resource.courses_parent.id
  path_part   = "{id}"
}

# Permissions
resource "aws_lambda_permission" "courses_child" {
  for_each = var.courses_child

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = each.value.name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.courses_api.execution_arn}/*/*"
}

# Integration
resource "aws_api_gateway_integration" "courses_child" {
  for_each = var.courses_child

  rest_api_id             = aws_api_gateway_rest_api.courses_api.id
  resource_id             = aws_api_gateway_resource.courses_child.id
  http_method             = each.value.method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = each.value.arn

  depends_on = [ aws_api_gateway_method.courses_child ]
}

# Method
resource "aws_api_gateway_method" "courses_child" {
  for_each = var.courses_child

  rest_api_id   = aws_api_gateway_rest_api.courses_api.id
  resource_id   = aws_api_gateway_resource.courses_child.id
  http_method   = each.value.method
  authorization = "NONE"
  api_key_required = false
}

# Response
resource "aws_api_gateway_method_response" "courses_child" {
  for_each = var.courses_child

  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.courses_child.id
  http_method = each.value.method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [ aws_api_gateway_deployment.deployment ]
}

# Integration Response
resource "aws_api_gateway_integration_response" "courses_child" {
  for_each = var.courses_child

  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.courses_child.id
  http_method = each.value.method
  status_code = "200"

  depends_on = [ aws_api_gateway_deployment.deployment ]
}
