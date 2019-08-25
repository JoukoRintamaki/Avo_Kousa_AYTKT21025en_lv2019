#!/bin/bash
set -x
docker run --detach --interactive --tty --name ubuntu ubuntu
docker exec ubuntu apt -qqq update
docker exec ubuntu apt -qqq -y install curl
docker exec --interactive ubuntu sh -c 'echo "Input website:"; read website; echo "Searching.."; sleep 1; curl http://$website;'
