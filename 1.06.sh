#!/bin/bash
set -x
EXERCISE=1.06
TAG=docker-clock
mkdir -p $EXERCISE

cat > $EXERCISE/Dockerfile << EOF
FROM devopsdockeruh/overwrite_cmd_exercise
ENTRYPOINT ["timeout","5s","./start.sh"]
CMD ["--clock 0"]
EOF

docker build --quiet --tag $TAG $EXERCISE 
docker run --name $TAG $TAG
docker rm $TAG --force --volumes