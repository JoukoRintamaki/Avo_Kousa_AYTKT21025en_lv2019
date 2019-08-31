docker stop $(docker ps --all --quiet) &>/dev/null
docker container prune --force
