#!/bin/bash

set -e
gitdir="$(pwd)/.git"

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

  tags="$(git log --pretty=format:'%h' -n 1) $(git rev-parse HEAD)"
  if [ "$tag" != "" ]; then
      tags="$tags $tag"
  fi

  tmpdir="$(TMPDIR="." tempfile)"
  rm -Rf "$tmpdir"
  git clone --depth 1 --single-branch --branch "$tag" "file://$gitdir" "$tmpdir"
  pushd "$tmpdir"
  git remote rm origin
  docker build . -t $(docker_registry_name)
  for tag in $tags; do
    docker tag $(docker_registry_name):latest "$(docker_registry):${tag}"
    docker push "$(docker_registry):${tag}"
  done
  popd

  rm -Rf "$tmpdir"
}

function publish {
  local tag="$1"

  if [ "$tag" = "" ]; then
    >&2 echo "Error: There must be a git tag to be published."
    exit 6
  fi

  if ! tag_exists "$tag"; then
    >&2 echo "Error: Git tag does not exist: $tag"
    exit 5
  fi

  docker_login
  deploy_docker_registry "$tag"
}

function tag_exists {
  local tag="$1"
  if GIT_DIR="$gitdir" git show-ref --tags | egrep -q "refs/tags/$1$"; then
    return 0 #true - it exists
  else
    return 1 #false - it does not
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
if [ ! -d "$gitdir" ]; then
  >&2 echo "Error: This directory is not a Git repository."
  exit 4
fi

case "$1" in
  "publish" )
    publish "$2";;
esac
