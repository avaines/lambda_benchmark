variable "aws_account_id" {
  type        = string
  description = "The AWS Account ID (numeric)"
}

variable "region" {
  type        = string
  description = "The AWS Region"
}

variable "environment" {
  type        = string
  description = "The environment variables are being inherited from"
}

variable "default_tags" {
  type        = map(string)
  description = "A map of default tags to apply to all taggable resources"
  default     = {}
}

variable "lambdas_to_deploy" {
  type        = map(string)
  description = "A map of which lambda's to deploy"
  default     = {}
}

variable "lambda_sizes" {
  type        = list(string)
  description = "A list of memory sizes to deploy for each lambda"
  default = [
    128,
    256,
    512,
    1024
  ]
}
