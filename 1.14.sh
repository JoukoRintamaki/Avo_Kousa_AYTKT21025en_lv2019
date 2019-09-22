#!/bin/bash
set -x
EXERCISE=1.14
DOCKERFILEFOLDER=$EXERCISE.Dockerfile
TAG=rails-example-project
PORT=3000
if [[ ! -e $DOCKERFILEFOLDER/Dockerfile ]]; then
	mkdir -p $DOCKERFILEFOLDER
	touch $DOCKERFILEFOLDER/Dockerfile
fi

cat > $DOCKERFILEFOLDER/Dockerfile <<EOF
FROM ruby:2.6.0
WORKDIR /usr/src/$TAG
RUN mkdir -p /usr/src/$TAG
RUN git clone https://github.com/docker-hy/$TAG.git /usr/src/$TAG 
RUN cd /usr/src/$TAG && bundle install && rails db:migrate RAILS_ENV=production && rake assets:precompile 
EXPOSE $PORT
CMD ["rails ","s","-e"."production"]
EOF

docker build --quiet --tag $TAG $DOCKERFILEFOLDER 
docker run --name $TAG --detach --publish $PORT:$PORT $TAG
sleep 20s
#curl --url http://localhost:$PORT
#wkhtmltoimage --quiet http://localhost:$PORT $EXERCISE.output.png
source dockercontainerprune.sh
