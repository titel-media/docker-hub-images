TERRAFORM_VERSION="$(cat Dockerfile-light | grep 'ENV TERRAFORM_VERSION=' | cut -d= -f2 | tr -d '\n')"

echo "${DOCKERHUB_PASS:?}" | docker login -u "${DOCKERHUB_USERNAME:?}" --password-stdin && \
  docker push titelmedia/terraform:light && \
  docker push titelmedia/terraform:${TERRAFORM_VERSION:?}
