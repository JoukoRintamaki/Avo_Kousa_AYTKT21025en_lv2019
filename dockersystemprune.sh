#!/bin/bash
docker stop $(docker ps --all --quiet) &>/dev/null 
docker system prune --volumes --all --force
