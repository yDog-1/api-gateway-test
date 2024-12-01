resource "aws_apigatewayv2_api" "frontend" {
  name          = "${local.kebab_project_name_prefix}-frontend_api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "frontend_lambda" {
  api_id                 = aws_apigatewayv2_api.frontend.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.frontend.arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.frontend.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.frontend_lambda.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.frontend.id
  name        = "$default"
  auto_deploy = true
}
