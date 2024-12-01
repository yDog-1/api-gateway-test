resource "aws_ecr_repository" "frontend" {
  name = "${local.kebab_project_name_prefix}-frontend"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "backend" {
  name = "${local.kebab_project_name_prefix}-backend"

  image_scanning_configuration {
    scan_on_push = true
  }
}

locals {
  ecr_repositories = [
    aws_ecr_repository.frontend.arn,
    aws_ecr_repository.backend.arn
  ]
}
