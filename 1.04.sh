#!/bin/bash
set -x
docker run --detach --name exec_bash_exercise devopsdockeruh/exec_bash_exercise | cat
docker exec exec_bash_exercise timeout 16 tail -f ./logs.txt
