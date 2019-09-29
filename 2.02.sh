#!/bin/bash
set -x
EXERCISE=2.02
TAG=ports_exercise
EXERCISEFOLDER=$EXERCISE.$TAG

if [[ ! -e $EXERCISEFOLDER/docker-compose.yml ]]; then
      mkdir -p $EXERCISEFOLDER
      touch $EXERCISEFOLDER/docker-compose.yml
fi

cat >$EXERCISEFOLDER/docker-compose.yml <<EOF
version: "3"
services:
      $TAG:
            image: devopsdockeruh/$TAG
            ports:
                  - 80:80
EOF

cd $EXERCISEFOLDER
docker-compose up --detach
sleep 10s
curl localhost:80
docker-compose down
