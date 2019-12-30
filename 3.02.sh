#!/bin/bash
set -e
EXERCISE=3.02
TAG=yle-dl

if [[ ! -e $EXERCISE/Dockerfile ]]; then
	mkdir -p $EXERCISE
	touch $EXERCISE/Dockerfile
fi

cat >$EXERCISE/Dockerfile <<EOF
FROM python
WORKDIR /usr/src/$TAG
RUN apt-get -qq update && \
    apt-get -qq install -y ffmpeg && \
    mkdir -p /usr/src/$TAG && \
    pip3 install --upgrade yle-dl
ENTRYPOINT ["/usr/local/bin/yle-dl","--destdir","/usr/src/$TAG"]
EOF

if [[ ! -e $EXERCISE/docker-compose.yml ]]; then
	mkdir -p $EXERCISE
	touch $EXERCISE/docker-compose.yml
fi

cat >$EXERCISE/docker-compose.yml <<EOF
version: "3.7"
services:
  $TAG:
    build: .
    container_name: $TAG
    image: $TAG
    volumes:
    - /c/Opt:/usr/src/$TAG
EOF

cd $EXERCISE
docker-compose build
docker-compose run yle-dl https://areena.yle.fi/1-3855204
ls /c/Opt/*.mkv