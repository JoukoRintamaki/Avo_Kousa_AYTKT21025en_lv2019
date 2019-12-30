#!/bin/bash
set -x
docker image pull --quiet ubuntu
docker run --detach --interactive --tty --name ubuntu ubuntu
docker exec ubuntu apt-get -qq update
docker exec ubuntu apt-get -qq install curl
echo helsinki.fi | docker exec --interactive ubuntu sh -c 'echo "Input website:"; read website; echo "Searching.."; sleep 1; curl http://$website;'
docker rm ubuntu --force --volumes