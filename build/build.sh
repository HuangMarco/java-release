#!/bin/bash

set -e -x -u -o pipefail

function build_jdk() {
  uuid=openjdk-$(uuidgen|tr '[:upper:]' '[:lower:]')
  rm -rf output/ && mkdir output/
  docker build --no-cache -t $uuid . >build.log 2>&1
  docker run --entrypoint= $uuid tar -cf - output/ | tar xvf - -C output/
  ls output/output/ | xargs -n1 -I{} bosh add-blob output/output/{} {}
  rm -rf output
}

echo "----> Docker"
docker -v

echo "----> OpenJDK 8"
pushd packages/openjdk-8/
  build_jdk
popd

echo "----> OpenJDK 9"
pushd packages/openjdk-9/
  build_jdk
popd
