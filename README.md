# tf-gcp-rails

## Prepareation
$ gcloud auth login
$ gcloud auth application-default login
$ gcloud config set project $GOOGLE_CLOUD_PROJECT

$ export TF_VAR_project_id="${GOOGLE_CLOUD_PROJECT}"
$ export TF_VAR_github_owner="your-github-owner"
$ export TF_VAR_github_repo="your-github-repo"

## TF
https://registry.terraform.io/providers/hashicorp/google/latest/docs

## MEMO
$ terraformer import google --projects=$GOOGLE_CLOUD_PROJECT --resources=networks --regions=asia-northeast1 --provider-type beta
$ terraformer import google --projects=$GOOGLE_CLOUD_PROJECT --resources=networks --regions=asia-northeast1

- https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/gcp.md

```
$ terraform apply -auto-approve -var="image_sha=$(git rev-parse --short HEAD)"
$ terraform apply -auto-approve -var="image_sha=$IMAGE_SHA"
$ terraform apply -auto-approve -var="image_sha=$IMAGE_SHA" -var="force=1"
```
