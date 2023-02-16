module "lambda_nodejs18" {
  for_each = local.lambdas_to_deploy["nodejs18"] ? toset(var.lambda_sizes) : []

  source = "github.com/terraform-module/terraform-aws-lambda?ref=v2.9.0"

  function_name  = "node18-${each.key}"
  filename       = "../aws/lambdas/nodejs18/nodejs18.zip"
  description    = "A nodeJS 18 lambda"
  handler        = "index.handler"
  runtime        = "nodejs18.x"
  memory_size    = "128"
  concurrency    = "5"
  lambda_timeout = "20"
  log_retention  = "1"
  role_arn       = aws_iam_role.main.arn
}
