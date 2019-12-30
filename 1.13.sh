#!/bin/bash
set -x
EXERCISE=1.13

TAG=spring-example-project
PORT=8080
mkdir -p $EXERCISE

cat > $EXERCISE/Dockerfile <<EOF
FROM openjdk:8 
WORKDIR /usr/src/$TAG
RUN mkdir -p /usr/src/$TAG
RUN git clone https://github.com/docker-hy/$TAG /usr/src/$TAG 
RUN cd /usr/src/$TAG && ./mvnw package 
EXPOSE $PORT
CMD ["java","-jar","./target/docker-example-1.1.3.jar"]
EOF

docker build --quiet --tag $TAG $EXERCISE 
docker run --name $TAG --detach --publish $PORT:$PORT $TAG
sleep 20s
curl --url http://localhost:$PORT
docker rm $TAG --force --volumes