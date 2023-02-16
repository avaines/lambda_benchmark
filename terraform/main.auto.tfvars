environment = "main"

lambdas_to_deploy = {
  go = false,
  python39 = false
  nodejs18 = false
  net7aot  = true
}

lambda_sizes = [128]
