# lambda_benchmark
AWS Lambda benchmarking resources

# Prep the deployment
Modify the terraform/main.auto.tfvars file to specific which lambdas you want deploying and what memory configurations

# Deploy the lambda
```
cd terraform
terraform fmt
terraform init
TF_VAR_region=us-east-1 TF_VAR_aws_account_id=${AWS_ACCOUNT_ID} terraform apply
```

# Destroy all the things
```
cd terraform
TF_VAR_region=us-east-1 TF_VAR_aws_account_id=${AWS_ACCOUNT_ID} terraform destroy
```
