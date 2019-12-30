#!/bin/bash
set -x
rm -f /c/Temp/logs.txt
touch /c/Temp/logs.txt
EXERCISE=2.01
TAG=first_volume_exercise

mkdir -p $EXERCISE

cat >$EXERCISE/docker-compose.yml <<EOF
version: "3"
services:
 $TAG:
  image: devopsdockeruh/$TAG
  container_name: $TAG
  volumes:
  - /c/Temp/logs.txt:/usr/app/logs.txt
EOF

cat /c/Temp/logs.txt
cd $EXERCISE && timeout 10s docker-compose up
cat /c/Temp/logs.txt
rm /c/Temp/logs.txt
docker rm $TAG --force --volumes