#!/bin/bash
set -x
TAG=ports_exercise
IMAGE=devopsdockeruh/ports_exercise
docker pull --quiet $IMAGE
docker run --detach --name $TAG --publish 80:80 $IMAGE
sleep 5s
curl --url http://localhost:80
docker rm $TAG --force --volumes