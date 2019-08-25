#!/bin/bash
docker stop $(docker ps --all --quiet) &>/dev/null 
docker container prune --force
#docker system prune --volumes --all --force
