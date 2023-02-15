data "archive_file" "lambda_python39" {
  count = local.lambdas_to_deploy["python39"] ? 1 : 0

  type        = "zip"
  source_file = "../aws/lambdas/python3.9/main.py"
  output_path = "lambda_function_python39.zip"
}

