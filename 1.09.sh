#!/bin/bash
set -x
IMAGE=devopsdockeruh/ports_exercise
docker pull --quiet $IMAGE
docker run --detach --publish 80:80 $IMAGE
sleep 5s
curl --url http://localhost:80
source dockercontainerprune.sh
