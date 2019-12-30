#!/bin/bash
set -x
docker image pull --quiet devopsdockeruh/exec_bash_exercise
docker run --detach --name exec_bash_exercise devopsdockeruh/exec_bash_exercise
docker exec exec_bash_exercise timeout 16 tail -f ./logs.txt
docker rm exec_bash_exercise --force --volumes