#!/bin/bash
set -x

EXERCISE=1.15
TAG=helloworld

mkdir -p $EXERCISE

cat > $EXERCISE/Dockerfile <<EOF
FROM alpine
CMD ["echo","Hello","World!"]
EOF

docker build --quiet --tag $TAG $EXERCISE 
docker run --name $TAG $TAG

docker tag $TAG joukorintamaki/$TAG
docker push joukorintamaki/$TAG

echo
echo
echo Public View:
echo
echo https://hub.docker.com/r/joukorintamaki/helloworld
echo
echo

docker rm $TAG --force --volumes