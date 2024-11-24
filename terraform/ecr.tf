resource "aws_ecr_repository" "frontend" {
  name = "${local.project_name_prifix}_frontend"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "backend" {
  name = "${local.project_name_prifix}_backend"

  image_scanning_configuration {
    scan_on_push = true
  }
}
