module "lambda_python39" {
  for_each = local.lambdas_to_deploy["python39"] ? toset(var.lambda_sizes) : []

  source = "github.com/terraform-module/terraform-aws-lambda?ref=v2.9.0"

  function_name  = "python39-${each.key}"
  filename       = "../aws/lambdas/python39/python39.zip"
  description    = "A python 3.9 lambda"
  handler        = "main.lambda_handler"
  runtime        = "python3.9"
  memory_size    = each.key
  concurrency    = "5"
  lambda_timeout = "20"
  log_retention  = "1"
  role_arn       = aws_iam_role.main.arn
}
