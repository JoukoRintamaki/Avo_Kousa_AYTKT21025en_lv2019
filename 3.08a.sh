#!/bin/bash
set -e
#install Azure Cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash	
#login to azure cloud service
az login
#set azure subscription
az account set --subscription 90770ece-195c-4c66-b939-887b721beaa1
#variables
PROJECT=devopswithdocker2019
LOCATION=westeurope
RESOURCE_GROUP=rg-$PROJECT
AKS_NAME=aks-$PROJECT
#get newest k8 version number
AKSVERSION=$(az aks get-versions -l $LOCATION --query 'orchestrators[-1].orchestratorVersion' -o tsv)
#create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION
#create azure kuberneter service
az aks create --resource-group $RESOURCE_GROUP --name $AKS_NAME --enable-addons monitoring --kubernetes-version $AKSVERSION --generate-ssh-keys --location $LOCATION
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME
kubectl get nodes

REGISTER=joukorintamaki
EXERCISE=3.08a
mkdir -p $EXERCISE
cat >$EXERCISE/docker-compose.yml <<EOF
version: "3"
services:
EOF

TAG=backend-example-docker
FOLDER=$EXERCISE/$TAG
PORT=8000
mkdir -p $FOLDER
cat >$FOLDER/Dockerfile <<EOF
FROM node:alpine
ENV FRONT_URL=http://localhost
RUN apk add --no-cache git && \
 mkdir -p /usr/src/$TAG && \
 git clone https://github.com/docker-hy/$TAG /usr/src/$TAG && \
 cd /usr/src/$TAG && \
 npm install && \
 apk del git
WORKDIR /usr/src/$TAG
EXPOSE $PORT
CMD ["npm","start"]
EOF
cat >>$EXERCISE/docker-compose.yml <<EOF
 $TAG:
  build: ./$TAG
  image: $REGISTER/$TAG
  container_name: $TAG
  environment:
   - REDIS=redis
   - DB_USERNAME=postgres
   - DB_PASSWORD=salasana
   - DB_HOST=postgres
  ports:
   - $PORT:$PORT
EOF

TAG=frontend-example-docker
FOLDER=$EXERCISE/$TAG
PORT=5000
mkdir -p $FOLDER
cat >$FOLDER/Dockerfile <<EOF
FROM node:alpine
ENV API_URL=http://localhost:8000
RUN apk add --no-cache git && \
 mkdir -p /usr/src/$TAG && \
 git clone https://github.com/docker-hy/$TAG /usr/src/$TAG && \
 cd /usr/src/$TAG && \
 npm install && \
 apk del git
WORKDIR /usr/src/$TAG
EXPOSE $PORT
CMD ["npm","start"]
EOF
cat >>$EXERCISE/docker-compose.yml <<EOF
 $TAG:
  build: ./$TAG
  image: $REGISTER/$TAG
  container_name: $TAG
  ports:
   - $PORT:$PORT
EOF

TAG=redis
cat >>$EXERCISE/docker-compose.yml <<EOF
 $TAG:
  container_name: $TAG
  image: $TAG:alpine
  ports:
    - 6379
EOF

TAG=postgres
cat >>$EXERCISE/docker-compose.yml <<EOF
 $TAG:
  container_name: $TAG
  image: $TAG:alpine  
  environment:
   - POSTGRES_USERNAME=postgres
   - POSTGRES_PASSWORD=salasana
  volumes:
   - database:/var/lib/postgresql/data
EOF

TAG=nginxservice
FOLDER=$EXERCISE/$TAG
mkdir -p $FOLDER
cat >$FOLDER/nginx.conf <<EOF
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
cat >$FOLDER/Dockerfile <<EOF
FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
EOF
cat >>$EXERCISE/docker-compose.yml <<EOF
 $TAG:  
  build: ./$TAG
  image: $REGISTER/$TAG  
  container_name: $TAG
  ports:
   - 80:80
  environment:
   - NGINX_PORT=80
EOF

cat >>$EXERCISE/docker-compose.yml <<EOF
volumes:
 database:
EOF

cd $EXERCISE

docker-compose build --parallel
docker-compose push
docker image ls

echo "docker stack deploy --orchestrator=kubernetes --compose-file docker-compose.yml $PROJECT"

#docker image remove frontend-example-docker backend-example-docker
#docker-compose up -d