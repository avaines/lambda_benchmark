output "lambda_arns" {
  value = concat(
    values(module.lambda_go)[*].arn,
    values(module.lambda_nodejs18)[*].arn,
    values(module.lambda_net7aot)[*].arn,
    values(module.lambda_python39)[*].arn,
  )
}

output "cloudwatch_log_groups" {
  value = concat(
    values(module.lambda_go)[*].cloudwatch_logs_arn,
    values(module.lambda_nodejs18)[*].cloudwatch_logs_arn,
    values(module.lambda_net7aot)[*].cloudwatch_logs_arn,
    values(module.lambda_python39)[*].cloudwatch_logs_arn,
  )
}
