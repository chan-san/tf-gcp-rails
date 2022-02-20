# tf-gcp-rails

## Prepareation
```
$ gcloud auth login
$ gcloud auth application-default login
$ gcloud config set project $GOOGLE_CLOUD_PROJECT
```

```
$ export TF_VAR_project_id="${GOOGLE_CLOUD_PROJECT}"
$ export TF_VAR_github_owner="your-github-owner"
$ export TF_VAR_github_repo="your-github-repo"
```

## TF
https://registry.terraform.io/providers/hashicorp/google/latest/docs
https://cloud.google.com/blog/ja/products/serverless/serverless-load-balancing-terraform-hard-way

## MEMO
```
$ terraformer import google --projects=$GOOGLE_CLOUD_PROJECT --resources=networks --regions=asia-northeast1 --provider-type beta
$ terraformer import google --projects=$GOOGLE_CLOUD_PROJECT --resources=networks --regions=asia-northeast1
```

- https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/gcp.md

```
$ terraform apply -auto-approve -var="image_sha=$(git rev-parse --short HEAD)"
$ terraform apply -auto-approve -var="image_sha=$IMAGE_SHA"
$ terraform apply -auto-approve -var="image_sha=$IMAGE_SHA"
$ terraform plan -var="image_sha=$IMAGE_SHA"  -target="google_cloud_run_service.migration-worker"  -target="google_cloud_run_service.worker" -target="google_cloud_run_service.app"
$ terraform import module.foo.aws_instance.bar i-abcd1234
$ terraform mv hoge.aaa module.foo.hoge.aaa
```

バックエンドをGCSに持っていくとき
```
$ terraform init --backend-config="bucket=terraform-state--${GOOGLE_CLOUD_PROJECT}"
```

Cloud SQL(パブリック)に接続する
```
$ cloud_sql_proxy -instances=${GOOGLE_CLOUD_PROJECT}:asia-northeast1:xxxx=tcp:55506
```