#!/bin/bash
set -x
rm -f /c/Temp/logs.txt
touch /c/Temp/logs.txt
EXERCISE=1.11
DOCKERFILEFOLDER=$EXERCISE.Dockerfile
TAG=backend-example-docker
PORT=8000
if [[ ! -e $DOCKERFILEFOLDER/Dockerfile ]]; then
	mkdir -p $DOCKERFILEFOLDER
	touch $DOCKERFILEFOLDER/Dockerfile
fi

cat > $DOCKERFILEFOLDER/Dockerfile <<EOF
FROM node
WORKDIR /usr/src/$TAG
RUN mkdir -p /usr/src/$TAG
RUN git clone https://github.com/docker-hy/$TAG /usr/src/$TAG 
RUN cd /usr/src/$TAG && npm install
EXPOSE $PORT
CMD ["npm","start"]
EOF

docker build --quiet --tag $TAG $DOCKERFILEFOLDER 
docker run --name $TAG --volume /c/Temp/logs.txt:/usr/src/$TAG/logs.txt --detach --publish $PORT:$PORT $TAG
sleep 10s
curl --url http://localhost:$PORT
cat /c/Temp/logs.txt
docker stop $TAG
sleep 10s
cat /c/Temp/logs.txt
docker start $TAG
sleep 10s
curl --url http://localhost:$PORT
cat /c/Temp/logs.txt
source dockercontainerprune.sh
