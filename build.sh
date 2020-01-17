#!/bin/bash

TAG=lambda-layer-aws-sdk-js

docker build -t $TAG . --build-arg DOCKER_MIRROR=${DOCKER_MIRROR-''}

CONTAINER=$(docker run -d $TAG false)
docker cp ${CONTAINER}:/root/layer.zip layer.zip
docker cp ${CONTAINER}:/root/VERSION VERSION
