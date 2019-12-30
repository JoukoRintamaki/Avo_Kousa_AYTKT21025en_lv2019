#!/bin/bash
set -e
EXERCISE=2.08

if [[ ! -e $EXERCISE/docker-compose.yml ]]; then
	mkdir -p $EXERCISE
	touch $EXERCISE/docker-compose.yml
fi

cat >$EXERCISE/docker-compose.yml <<EOF
version: "3.7"
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
ENV FRONT_URL=http://localhost
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
  environment:
   - REDIS=redis
   - DB_USERNAME=postgres
   - DB_PASSWORD=salasana
   - DB_HOST=postgres
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

TAG=redis
cat >>$EXERCISE/docker-compose.yml <<EOF
 $TAG:
  container_name: $TAG
  image: $TAG
  ports:
    - 6379
EOF

TAG=postgres
cat >>$EXERCISE/docker-compose.yml <<EOF
 $TAG:
  container_name: $TAG
  image: $TAG
  restart: unless-stopped
  environment:
   - POSTGRES_USERNAME=postgres
   - POSTGRES_PASSWORD=salasana
EOF

TAG=nginx
cat >>$EXERCISE/docker-compose.yml <<EOF
 $TAG:
  container_name: $TAG
  image: $TAG
  ports:
   - 80:80
  environment:
   - NGINX_PORT=80
  volumes:
   - /c/Temp/nginx.conf:/etc/nginx/nginx.conf
EOF

cat >/c/Temp/nginx.conf <<EOF
events { worker_connections 1024; }
http {
 server {
  listen 80;

  location / {
   proxy_pass http://frontend-example-docker:5000/;
  }

  location /api/ {
   proxy_pass http://backend-example-docker:8000/;
  }
 }
}
EOF

cd $EXERCISE
docker-compose up --detach --quiet-pull
sleep 30s
docker-compose down
docker image remove frontend-example-docker backend-example-docker