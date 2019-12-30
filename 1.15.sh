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

cat > $EXERCISE/ReadMe.md << EOF
# How to run

Docker print "Hello World!" string.
EOF

docker rm $TAG --force --volumes