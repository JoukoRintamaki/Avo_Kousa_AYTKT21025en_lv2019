#!/bin/bash
set -x
EXERCISE=1.12

mkdir -p $EXERCISE

TAG=backend-example-docker
PORT=8000
cat > $EXERCISE/Dockerfile.$TAG <<EOF
FROM node
ENV FRONT_URL=http://localhost:5000
WORKDIR /usr/src/$TAG
RUN mkdir -p /usr/src/$TAG
RUN git clone https://github.com/docker-hy/$TAG /usr/src/$TAG
RUN cd /usr/src/$TAG && npm install
EXPOSE $PORT
CMD ["npm","start"]
EOF
docker build --quiet --tag $TAG --file $EXERCISE/Dockerfile.$TAG $EXERCISE
docker run --name $TAG --detach --publish $PORT:$PORT $TAG

TAG=frontend-example-docker
PORT=5000	
cat > $EXERCISE/Dockerfile.$TAG <<EOF
FROM node
ENV API_URL=http://localhost:8000
WORKDIR /usr/src/$TAG
RUN mkdir -p /usr/src/$TAG
RUN git clone https://github.com/docker-hy/$TAG /usr/src/$TAG
RUN cd /usr/src/$TAG && npm install
EXPOSE $PORT
CMD ["npm","start"]
EOF
docker build --quiet --tag $TAG --file $EXERCISE/Dockerfile.$TAG $EXERCISE
docker run --name $TAG --detach --publish $PORT:$PORT $TAG

sleep 30s
curl --url http://localhost:$PORT
docker rm frontend-example-docker --force --volumes
docker rm backend-example-docker --force --volumes