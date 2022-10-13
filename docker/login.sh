#!/usr/bin/env bash

readonly docker_repositories_file="repositories.yaml"

yq eval $docker_repositories_file
REPOSITORIES_YAML=$(yq eval $docker_repositories_file)
if [[ $? != 0 ]]; then
  echo "Failed to find $docker_repositories_file"
  exit 1
fi
for REPOSITORY in $(echo $REPOSITORIES_YAML | yq '.repositories'); do
    echo "Login to Docker registry at $REPOSITORY"
    docker login $REPOSITORY
done