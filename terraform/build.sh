TERRAFORM_VERSION="$(cat Dockerfile-light | grep 'ENV TERRAFORM_VERSION=' | cut -d= -f2 | tr -d '\n')"

docker build -t titelmedia/terraform:light -f Dockerfile-light .
docker tag titelmedia/terraform:light "titelmedia/terraform:${TERRAFORM_VERSION:?}"
