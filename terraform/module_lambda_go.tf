module "lambda_go" {
  for_each = local.lambdas_to_deploy["go"] ? toset(var.lambda_sizes) : []

  source = "github.com/terraform-module/terraform-aws-lambda?ref=v2.9.0"

  function_name  = "go-${each.key}"
  filename       = data.archive_file.lambda_go[0].output_path
  description    = "A GoLang lambda"
  handler        = "main"
  runtime        = "go1.x"
  memory_size    = "128"
  concurrency    = "5"
  lambda_timeout = "20"
  log_retention  = "1"
  role_arn       = aws_iam_role.main.arn
}
