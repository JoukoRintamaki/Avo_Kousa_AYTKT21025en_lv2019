#!/bin/bash
set -x
docker image pull --quiet devopsdockeruh/first_volume_exercise
rm -f /c/Temp/logs.txt
touch /c/Temp/logs.txt
timeout 10s docker run --volume /c/Temp/logs.txt:/usr/app/logs.txt devopsdockeruh/first_volume_exercise
cat /c/Temp/logs.txt
rm -f /c/Temp/logs.txt
source dockercontainerprune.sh 
