locals {
  default_tags = merge(
    var.default_tags,
    {
      Project     = "Lambda Benchmark"
      Environment = var.environment
    },
  )

  lambdas_to_deploy = merge(
    {
      go       = true
      python39 = true
      nodejs18 = true
      net7aot  = true
    },
    var.lambdas_to_deploy
  )
}
