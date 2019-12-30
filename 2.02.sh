#!/bin/bash
set -x
EXERCISE=2.02
TAG=ports_exercise

mkdir -p $EXERCISE

cat >$EXERCISE/docker-compose.yml <<EOF
version: "3"
services:
 $TAG:
  image: devopsdockeruh/$TAG
  ports:
  - 80:80
EOF

cd $EXERCISE
docker-compose up --detach
sleep 10s
curl localhost:80
echo
docker-compose down