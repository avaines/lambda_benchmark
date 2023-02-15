data "archive_file" "lambda_nodejs18" {
  count = local.lambdas_to_deploy["nodejs18"] ? 1 : 0

  type        = "zip"
  source_file = "../aws/lambdas/nodejs18/index.js"
  output_path = "lambda_function_nodejs18.zip"
}

