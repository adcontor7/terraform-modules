##Terraform modules Example usages

## Assumptions

* You have an AWS account

## How to use

1- Provide AWS credentials
```bash
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"
```

2- Deploy
```bash
cd example1
terraform init
terraform plan
terraform apply
```

3- Destroy

```bash
terraform destroy
```
