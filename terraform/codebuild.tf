resource "aws_codebuild_project" "frontend_lambda_deploy" {
  name          = "${local.kebab_project_name_prefix}-frontend-lambda-deploy"
  description   = "Deploys new images to Lambda upon ECR updates"
  build_timeout = 5
  service_role  = aws_iam_role.frontend_codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    type         = "LINUX_LAMBDA_CONTAINER"
    compute_type = "BUILD_LAMBDA_1GB"
    image        = "aws/codebuild/amazonlinux-x86_64-lambda-standard:nodejs20"
  }

  source {
    type      = "NO_SOURCE"
    buildspec = <<-EOT
      version: 0.2
      phases:
        build:
          commands:
            - echo "Deploying new image to Lambda"
            - aws lambda update-function-code --function-name ${aws_lambda_function.frontend.function_name} --image-uri ${aws_ecr_repository.frontend.repository_url}:latest
      EOT
  }
}
