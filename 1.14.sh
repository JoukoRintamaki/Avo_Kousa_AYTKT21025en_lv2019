#!/bin/bash
set -x

EXERCISE=1.14
TAG=rails-example-project
PORT=3000

mkdir -p $EXERCISE

cat > $EXERCISE/Dockerfile <<EOF
FROM ruby:2.6.0
WORKDIR /usr/src/$TAG
RUN mkdir -p /usr/src/$TAG
RUN git clone https://github.com/docker-hy/$TAG.git /usr/src/$TAG 
RUN cd /usr/src/$TAG && bundle install
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN rails db:migrate
RUN rake assets:precompile
EXPOSE $PORT
CMD ["rails","s"]
EOF

docker build --quiet --tag $TAG $EXERCISE 
docker run --name $TAG --detach --publish $PORT:$PORT $TAG
sleep 25s
curl --url http://localhost:$PORT
docker rm $TAG --force --volumes