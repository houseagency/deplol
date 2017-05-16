#!/bin/bash

function docker_login {
  `aws ecr get-login --region eu-west-1`
}

function docker_registry {
  echo "${DOCKER_REGISTRY_HOST}/${DOCKER_REGISTRY_NAME}"
}

function deploy_docker_registry {
  local registry="$(docker_registry)"
  docker build . -t $DOCKER_REGISTRY_NAME
  for tag in "$(git log --pretty=format:'%h' -n 1)" \
             "$(git rev-parse HEAD)" \
	     "latest"; do
    docker tag ${DOCKER_REGISTRY_NAME}:latest "${registry}:${tag}"
    docker push "${registry}:${tag}"
  done
}

function publish {
  if [ "$AWS_ACCESS_KEY_ID$AWS_SECRET_ACCESS_KEY" = "" ]; then
    >&2 echo "Error: No AWS credential enviroment variables (AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY required)."
    exit 1
  fi
  if [ "$(docker_registry)" = "/" ]; then
    >&2 echo "Error: No DOCKER_REGISTRY_HOST and DOCKER_REGISTRY_NAME environment variables."
    exit 1
  fi

  docker_login
  deploy_docker_registry
}

case "$1" in
  "publish" )
    publish;;
esac
