#!/bin/bash
set -x
DOCKERFILEFOLDER=1.10.Dockerfile
if [[ ! -e $DOCKERFILEFOLDER/Dockerfile ]]; then
	mkdir -p $DOCKERFILEFOLDER
	touch $DOCKERFILEFOLDER/Dockerfile
fi

cat > $DOCKERFILEFOLDER/Dockerfile << 'EOF'
FROM node
WORKDIR /usr/src/frontend-example-docker
RUN mkdir -p /usr/src/frontend-example-docker
RUN git clone https://github.com/docker-hy/frontend-example-docker.git /usr/src/frontend-example-docker
RUN cd /usr/src/frontend-example-docker && npm install
EXPOSE 5000
CMD ["npm","start"]
EOF

docker build --quiet --tag frontend-example-docker $DOCKERFILEFOLDER 
docker run --detach --publish 5000:5000 frontend-example-docker 
sleep 60s
curl --url http://localhost:5000
source dockercontainerprune.sh
