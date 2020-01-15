#!/bin/bash
set -ex

#install Azure Cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash	
#login to azure cloud service
az login --output none
#set azure subscription
az account set --subscription b9b3fbea-71e8-49dd-9aab-0bae7424d14c --output none
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
#install k8s cli
az aks install-cli
#connect aks
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME
#list nodes
kubectl get nodes

#variables
REGISTER=joukorintamaki
EXERCISE=3.08a
mkdir -p $EXERCISE

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
docker build --tag $REGISTER/$TAG $FOLDER
docker push $REGISTER/$TAG

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
docker build --tag $REGISTER/$TAG $FOLDER
docker push $REGISTER/$TAG

cat >$EXERCISE/deploy.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: frontend-example-docker
  name: frontend-example-docker
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend-example-docker
  template:
    metadata:
      labels:
        app: frontend-example-docker
    spec:
      containers:
        - image: joukorintamaki/frontend-example-docker
          name: frontend-example-docker
          ports:
            - containerPort: 5000
      nodeSelector:
        kubernetes.io/hostname: aks-nodepool1-16828242-vmss000000
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: backend-example-docker
  name: backend-example-docker
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend-example-docker
  template:
    metadata:
      labels:
        app: backend-example-docker
    spec:
      containers:
        - image: joukorintamaki/backend-example-docker
          name: backend-example-docker
          ports:
            - containerPort: 8000
      nodeSelector:
        kubernetes.io/hostname: aks-nodepool1-16828242-vmss000001
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: frontend-example-docker
  name: frontend-example-docker
spec:
  ports:
    - port: 80
      protocol: TCP
      targetPort: 5000
  selector:
    app: frontend-example-docker
  type: LoadBalancer
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: backend-example-docker
  name: backend-example-docker
spec:
  ports:
    - port: 8000
      protocol: TCP
      targetPort: 8000
  selector:
    app: backend-example-docker
  type: LoadBalancer
EOF

cd $EXERCISE
kubectl apply -f deploy.yaml
sleep 10m
kubectl get deployments,pods,services,endpoints -o wide
