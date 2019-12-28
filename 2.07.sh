#!/bin/bash
set -e
EXERCISE=2.07
GIT_PARENT_URL=https://github.com/docker-hy/

if [[ ! -e $EXERCISE/docker-compose.yml ]]; then
	mkdir -p $EXERCISE
	touch $EXERCISE/docker-compose.yml
fi

cat >$EXERCISE/docker-compose.yml <<EOF
version: "3.7"
services:
EOF

TAG=ml-kurkkumopo-backend
PORT=5000
cat >>$EXERCISE/docker-compose.yml <<EOF
 $TAG:
  build: $GIT_PARENT_URL$TAG.git
  container_name: $TAG
  ports:
   - $PORT:$PORT
  volumes:
   - model:/src/model
  image: $TAG
EOF

TAG=ml-kurkkumopo-frontend
PORT=3000
cat >>$EXERCISE/docker-compose.yml <<EOF
 $TAG:
  build: $GIT_PARENT_URL$TAG.git
  container_name: $TAG
  ports:
   - $PORT:$PORT
  image: $TAG
EOF

TAG=ml-kurkkumopo-training
cat >>$EXERCISE/docker-compose.yml <<EOF
 $TAG:
  build: $GIT_PARENT_URL$TAG.git
  container_name: $TAG
  image: $TAG
  volumes:
   - imgs:/src/imgs
   - model:/src/model
EOF

cat >>$EXERCISE/docker-compose.yml <<EOF
volumes:
 imgs:
 model:
EOF

cd $EXERCISE
docker-compose up --detach
#sleep 30s
#docker-compose down
