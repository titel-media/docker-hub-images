# Retrive latest version of terraform
LATEST=$(curl -s https://github.com/hashicorp/terraform/releases/latest | cut -d\" -f2 | rev | cut -dv -f1 | rev)
CURRENT=$(cat terraform/Dockerfile-light | grep "ENV TERRAFORM_VERSION" | cut -d= -f2)

echo "Latest terraform release $LATEST"
echo "Current terraform release $CURRENT"

if [ "$LATEST" != "$CURRENT" ]; then
  echo "Update terraform version from $CURRENT to $LATEST"
  sed -i '' "s/TERRAFORM_VERSION=$CURRENT/TERRAFORM_VERSION=$LATEST/g" terraform/Dockerfile-light

  echo "Retrieve new version fingerprint"
  LATEST_SHA256SUM=$(curl -s https://releases.hashicorp.com/terraform/$LATEST/terraform_${LATEST}_SHA256SUMS | grep linux_amd64 | cut -f1 -d' ')
  CURRENT_SHA256SUM=$(cat terraform/Dockerfile-light | grep "ENV TERRAFORM_SHA256SUM" | cut -d= -f2)
  sed -i '' "s/TERRAFORM_SHA256SUM=$CURRENT_SHA256SUM/TERRAFORM_SHA256SUM=$LATEST_SHA256SUM/g" terraform/Dockerfile-light

  git add terraform/Dockerfile-light && \
    git commit -m "Bump terraform version $CURRENT => $LATEST" && \
    git tag terraform_$LATEST && \
    git push --follow-tags

  cd terraform && \
    ./build.sh && \
    echo "now ./release.sh" && \
    cd ..
else
  echo "Terraform version is up to date"
fi
