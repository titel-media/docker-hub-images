TERRAFORM_VERSION="$(cat Dockerfile-light | grep 'ENV TERRAFORM_VERSION=' | cut -d= -f2 | tr -d '\n')"

docker build -t titelmedia/terraform:latest -f Dockerfile-light .
docker tag titelmedia/terraform:latest "titelmedia/terraform:${TERRAFORM_VERSION:?}"
