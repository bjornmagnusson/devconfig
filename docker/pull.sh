#!/usr/bin/env bash

readonly docker_images_file="images.yaml"

yq eval $docker_images_file
IMAGES_YAML=$(yq eval $docker_images_file)
if [[ $? != 0 ]]; then
  echo "Failed to find $docker_images_file"
  exit 1
fi
for IMAGE in $(echo $IMAGES_YAML | yq '.images'); do
    echo "Pulling image $IMAGE"
    docker image pull $IMAGE
done