#!/bin/bash

set -e

function docker_login {
  `aws ecr get-login --region eu-west-1`
}

function docker_registry_host {
  docker_registry | sed -r 's/\/.*//'
}

function docker_registry_name {
  docker_registry | sed -r 's/^[^\/]*\///'
}

function docker_registry {
  cat .deplol_registry 2>/dev/null | head -1
}

function deploy_docker_registry {
  local registry="$(docker_registry)"
  local tag="$1"

  tags="$(git log --pretty=format:'%h' -n 1) $(git rev-parse HEAD) latest"
  if [ "$tag" != "" ]; then
      tags="$tags $tag"
  fi

  docker build . -t $(docker_registry_name)

  for tag in $tags; do
    docker tag $(docker_registry_name):latest "$(docker_registry):${tag}"
    docker push "$(docker_registry):${tag}"
  done
}

function publish {
  local tag="$1"
  docker_login
  if [ "$tag" = "" ]; then
    deploy_docker_registry
  else
    git tag -f -a "$tag" -m "Tagged using deplol: https://github.com/houseagency/deplol"
    deploy_docker_registry "$tag"
  fi
}

if [ "$AWS_ACCESS_KEY_ID$AWS_SECRET_ACCESS_KEY" = "" ]; then
  >&2 echo "Error: No AWS credential enviroment variables (AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY required)."
  exit 1
fi
if [ ! -e Dockerfile ]; then
  >&2 echo "Error: No Dockerfile in this directory."
  exit 2
fi
if [ "$(docker_registry)" = "" ];then
  >&2 echo "Error: No .deplol_registry file in this directory."
  exit 3
fi
if [ ! -e .git ]; then
  >&2 echo "Error: This directory is not a Git repository."
  exit 4
fi

case "$1" in
  "publish" )
    publish "$2";;
esac
