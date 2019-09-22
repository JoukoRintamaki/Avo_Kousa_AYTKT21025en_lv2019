#!/bin/bash
set -x
EXERCISE=1.12

DOCKERFILEFOLDER=$EXERCISE.Backend.Dockerfile
TAG=backend-example-docker
PORT=8000
if [[ ! -e $DOCKERFILEFOLDER/Dockerfile ]]; then
	mkdir -p $DOCKERFILEFOLDER
	touch $DOCKERFILEFOLDER/Dockerfile
fi

cat > $DOCKERFILEFOLDER/Dockerfile <<EOF
FROM node
ENV FRONT_URL=http://localhost:5000
WORKDIR /usr/src/$TAG
RUN mkdir -p /usr/src/$TAG
RUN git clone https://github.com/docker-hy/$TAG /usr/src/$TAG
RUN cd /usr/src/$TAG && npm install
EXPOSE $PORT
CMD ["npm","start"]
EOF

docker build --quiet --tag $TAG $DOCKERFILEFOLDER
docker run --name $TAG --detach --publish $PORT:$PORT $TAG


DOCKERFILEFOLDER=$EXERCISE.Frontend.Dockerfile
TAG=frontend-example-docker
PORT=5000
if [[ ! -e $DOCKERFILEFOLDER/Dockerfile ]]; then
	mkdir -p $DOCKERFILEFOLDER
	touch $DOCKERFILEFOLDER/Dockerfile
fi

cat > $DOCKERFILEFOLDER/Dockerfile <<EOF
FROM node
ENV API_URL=http://localhost:8000
WORKDIR /usr/src/$TAG
RUN mkdir -p /usr/src/$TAG
RUN git clone https://github.com/docker-hy/$TAG /usr/src/$TAG
RUN cd /usr/src/$TAG && npm install
EXPOSE $PORT
CMD ["npm","start"]
EOF

docker build --quiet --tag $TAG $DOCKERFILEFOLDER
docker run --name $TAG --detach --publish $PORT:$PORT $TAG
sleep 30s
curl --url http://localhost:$PORT
source dockercontainerprune.sh