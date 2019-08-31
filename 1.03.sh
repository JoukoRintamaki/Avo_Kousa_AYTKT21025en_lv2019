#!/bin/bash
set -x
docker pull --quiet devopsdockeruh/pull_exercise
docker run --tty --interactive devopsdockeruh/pull_exercise sh -c "echo basics | node index.js"
source dockercontainerprune.sh
