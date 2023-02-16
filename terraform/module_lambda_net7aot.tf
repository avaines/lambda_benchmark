module "lambda_net7aot" {
  for_each = local.lambdas_to_deploy["net7aot"] ? toset(var.lambda_sizes) : []

  source = "github.com/terraform-module/terraform-aws-lambda?ref=v2.9.0"

  function_name  = "net7aot-${each.key}"
  filename       = "../aws/lambdas/net7aot/net7aot.zip"
  description    = "A .net7 AOT lambda"
  handler        = "main"
  runtime        = "provided.al2"
  memory_size    = "128"
  concurrency    = "5"
  lambda_timeout = "20"
  log_retention  = "1"
  role_arn       = aws_iam_role.main.arn
}
