provider "aws" {
  region = var.region

  default_tags {
    tags = local.default_tags
  }

  allowed_account_ids = [
    var.aws_account_id,
  ]
}
