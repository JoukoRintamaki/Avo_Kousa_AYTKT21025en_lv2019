#!/bin/bash
set -x
EXERCISE=1.07
TAG=curler
mkdir -p $EXERCISE

cat > $EXERCISE/Dockerfile << 'EOF'
FROM ubuntu
RUN apt-get -qq update && apt-get -qq install curl
CMD echo "Input website:"; read website; echo "Searching.."; sleep 1; curl http://$website;
EOF

docker build --quiet --tag $TAG $EXERCISE 
echo helsinki.fi | docker run --interactive --name $TAG $TAG
docker rm $TAG --force --volumes