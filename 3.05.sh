#!/bin/bash
set -x
EXERCISE=3.05
TAG=frontend-example-docker
PORT=5000
mkdir -p $EXERCISE

cat > $EXERCISE/Dockerfile <<EOF
FROM node as build
WORKDIR /usr/src/$TAG
RUN mkdir -p /usr/src/frontend-example-docker && \
git clone https://github.com/docker-hy/frontend-example-docker.git /usr/src/$TAG && \
cd /usr/src/$TAG && npm install

FROM node:alpine
WORKDIR /frontend-example-docker
COPY --from=build /usr/src/frontend-example-docker /frontend-example-docker
EXPOSE $PORT
CMD ["npm","start"]
EOF

docker build --quiet --tag $TAG $EXERCISE 
docker run --detach --publish $PORT:$PORT --name $TAG $TAG 
sleep 30s
curl --url http://localhost:$PORT
cutycapt --url=http://localhost:$PORT --out=$EXERCISE.output.png
docker rm $TAG --force --volumes