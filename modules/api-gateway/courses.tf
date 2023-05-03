# Resources
resource "aws_api_gateway_resource" "courses_parent" {
  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  parent_id   = aws_api_gateway_rest_api.courses_api.root_resource_id
  path_part   = "courses"
}

#resource "aws_api_gateway_resource" "courses courses_child" {
  #rest_api_id = aws_api_gateway_rest_api.courses_api.id
  #parent_id   = aws_api_gateway_resource.courses_parent.id
  #path_part   = "{id}"
#}

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

  depends_on = [ aws_api_gateway_deployment.deployment ]
}

# Integration Response
resource "aws_api_gateway_integration_response" "courses_parent" {
  for_each = var.courses_parent

  rest_api_id = aws_api_gateway_rest_api.courses_api.id
  resource_id = aws_api_gateway_resource.courses_parent.id
  http_method = each.value.method
  status_code = "200"

  response_templates = {
    "application/json" = "Empty"
  }

  depends_on = [ aws_api_gateway_deployment.deployment ]
}
