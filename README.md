# lambda_benchmark
AWS Lambda benchmarking resources

# Prep the deployment
Modify the terraform/main.auto.tfvars file to specify which lambdas you want deploying and what memory configurations

# Build the lambda functions manually
```
pushd aws/lambdas
./build_lambdas.sh
popd
```

# Deploy the lambda
(This will also build the lambda function packages)
```
pushd terraform
terraform fmt && terraform init
TF_VAR_region=us-east-1 TF_VAR_aws_account_id=${AWS_ACCOUNT_ID} terraform apply
popd
```

# Invoke functions and generate the report
```
python scripts/reports/generate_lambda_start_report.py --invocations 5 --cycles 5 --pause 10
```

# Destroy all the things
```
pushd terraform
TF_VAR_region=us-east-1 TF_VAR_aws_account_id=${AWS_ACCOUNT_ID} terraform destroy
popd
```
