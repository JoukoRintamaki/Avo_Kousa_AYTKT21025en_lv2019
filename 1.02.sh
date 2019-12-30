#!/bin/bash
set -x
docker stop $(docker ps --all --quiet) &>/dev/null 
docker system prune --volumes --all --force
docker ps --all
docker images