#!/bin/bash
set -x
EXERCISE=1.10
DOCKERFILEFOLDER=$EXERCISE.Dockerfile
TAG=frontend-example-docker
PORT=5000
if [[ ! -e $DOCKERFILEFOLDER/Dockerfile ]]; then
	mkdir -p $DOCKERFILEFOLDER
	touch $DOCKERFILEFOLDER/Dockerfile
fi

cat > $DOCKERFILEFOLDER/Dockerfile <<EOF
FROM node
WORKDIR /usr/src/frontend-example-docker
RUN mkdir -p /usr/src/frontend-example-docker
RUN git clone https://github.com/docker-hy/frontend-example-docker.git /usr/src/frontend-example-docker
RUN cd /usr/src/frontend-example-docker && npm install
EXPOSE $PORT
CMD ["npm","start"]
EOF

docker build --quiet --tag $TAG $DOCKERFILEFOLDER 
docker run --detach --publish $PORT:$PORT $TAG 
sleep 60s
curl --url http://localhost:$PORT
wkhtmltoimage --quiet http://localhost:$PORT $EXERCISE.output.png
source dockercontainerprune.sh
