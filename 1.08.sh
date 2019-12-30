#!/bin/bash
set -x
TAG=first_volume_exercise
docker image pull --quiet devopsdockeruh/first_volume_exercise
rm -f /c/Temp/logs.txt
touch /c/Temp/logs.txt
timeout 10s docker run --volume /c/Temp/logs.txt:/usr/app/logs.txt --name $TAG devopsdockeruh/first_volume_exercise
cat /c/Temp/logs.txt
rm -f /c/Temp/logs.txt
docker rm $TAG --force --volumes