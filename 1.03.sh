#!/bin/bash
set -x
docker pull --quiet devopsdockeruh/pull_exercise
docker run --name pull_exercise --tty --interactive devopsdockeruh/pull_exercise sh -c "echo basics | node index.js"
docker rm pull_exercise --volumes