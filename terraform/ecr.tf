resource "aws_ecr_repository" "frontend" {
  name = "api-gateway-test_frontend"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "backend" {
  name = "api-gateway-test_backend"

  image_scanning_configuration {
    scan_on_push = true
  }
}
