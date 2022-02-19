# Sampleアプリ

- gcloud auth configure-docker asia-northeast1-docker.pkg.dev  

```
docker build -t tf-gcp-rails .
IMAGE_ID=`docker images tf-gcp-rails -q`
docker tag tf-gcp-rails asia-northeast1-docker.pkg.dev/$GOOGLE_CLOUD_PROJECT/tf-gcp-rails/rails:$IMAGE_ID
docker push asia-northeast1-docker.pkg.dev/$GOOGLE_CLOUD_PROJECT/tf-gcp-rails/rails:$IMAGE_ID
docker rmi tf-gcp-rails asia-northeast1-docker.pkg.dev/$GOOGLE_CLOUD_PROJECT/tf-gcp-rails/rails:$IMAGE_ID
```
