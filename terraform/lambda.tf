resource "aws_lambda_function" "frontend" {
  function_name = "${local.kebab_project_name_prefix}-frontend"
  role          = aws_iam_role.frontend_lambda_execution_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.frontend.repository_url}:latest"

  timeout     = 5
  memory_size = 128
  ephemeral_storage {
    size = 512
  }
}

resource "aws_lambda_permission" "frontend_allow_apigateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.frontend.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_apigatewayv2_api.frontend.execution_arn
}

# resource "aws_lambda_function" "backend" {
#   function_name = "api-gateway-test_backend"
#   memory_size   = 128
#   ephemeral_storage {
#     size = 512
#   }
#   timeout = 3

#   package_type = "Image"
#   image_uri    = "${aws_ecr_repository.backend_repo.repository_url}:latest"
#   role         = aws_iam_role.lambda_role.arn
# }
