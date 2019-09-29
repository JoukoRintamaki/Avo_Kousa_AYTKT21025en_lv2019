#!/bin/bash
set -x
EXERCISE=2.03

if [[ ! -e $EXERCISE/docker-compose.yml ]]; then
	mkdir -p $EXERCISE
	touch $EXERCISE/docker-compose.yml
fi

cat >$EXERCISE/docker-compose.yml <<EOF
version: "3.3"
services:
EOF

TAG=backend-example-docker
FOLDER=$EXERCISE/$TAG
PORT=8000
if [[ ! -e $FOLDER/Dockerfile ]]; then
	mkdir -p $FOLDER
	touch $FOLDER/Dockerfile
fi

cat >$FOLDER/Dockerfile <<EOF
FROM node
ENV FRONT_URL=http://localhost:5000
WORKDIR /usr/src/$TAG
RUN mkdir -p /usr/src/$TAG
RUN git clone https://github.com/docker-hy/$TAG /usr/src/$TAG
RUN cd /usr/src/$TAG && npm install
EXPOSE $PORT
CMD ["npm","start"]
EOF

cat >>$EXERCISE/docker-compose.yml <<EOF
 $TAG:
  build: ./$TAG
  container_name: $TAG
  ports:
   - $PORT:$PORT
  image: $TAG

EOF

TAG=frontend-example-docker
FOLDER=$EXERCISE/$TAG
PORT=5000
if [[ ! -e $FOLDER/Dockerfile ]]; then
	mkdir -p $FOLDER
	touch $FOLDER/Dockerfile
fi

cat >$FOLDER/Dockerfile <<EOF
FROM node
ENV API_URL=http://localhost:8000
WORKDIR /usr/src/$TAG
RUN mkdir -p /usr/src/$TAG
RUN git clone https://github.com/docker-hy/$TAG /usr/src/$TAG
RUN cd /usr/src/$TAG && npm install
EXPOSE $PORT
CMD ["npm","start"]
EOF

cat >>$EXERCISE/docker-compose.yml <<EOF
 $TAG:
  build: ./$TAG
  container_name: $TAG
  ports:
   - $PORT:$PORT
  image: $TAG
EOF

cd $EXERCISE
docker-compose up --detach --no-color
sleep 60s
curl localhost:5000
docker-compose down