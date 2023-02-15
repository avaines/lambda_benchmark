data "archive_file" "lambda_go" {
  count = local.lambdas_to_deploy["go"] ? 1 : 0

  type        = "zip"
  source_file = "../aws/lambdas/go/main.go"
  output_path = "lambda_function_go.zip"
}

