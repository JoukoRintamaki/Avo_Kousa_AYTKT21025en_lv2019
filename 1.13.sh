#!/bin/bash
set -x
EXERCISE=1.13
DOCKERFILEFOLDER=$EXERCISE.Dockerfile
TAG=spring-example-project
PORT=8080
if [[ ! -e $DOCKERFILEFOLDER/Dockerfile ]]; then
	mkdir -p $DOCKERFILEFOLDER
	touch $DOCKERFILEFOLDER/Dockerfile
fi

cat > $DOCKERFILEFOLDER/Dockerfile <<EOF
FROM openjdk:8 
WORKDIR /usr/src/$TAG
RUN mkdir -p /usr/src/$TAG
RUN git clone https://github.com/docker-hy/$TAG /usr/src/$TAG 
RUN cd /usr/src/$TAG && ./mvnw package 
EXPOSE $PORT
CMD ["java","-jar","./target/docker-example-1.1.3.jar"]
EOF

docker build --quiet --tag $TAG $DOCKERFILEFOLDER 
docker run --name $TAG --detach --publish $PORT:$PORT $TAG
sleep 20s
curl --url http://localhost:$PORT
source dockercontainerprune.sh
