#!/bin/bash
set -e
EXERCISE=2.04
rm -Rf $EXERCISE
wget https://github.com/docker-hy/scaling-exercise/archive/master.zip
unzip master.zip
mv scaling-exercise-master $EXERCISE
rm master.zip
cd $EXERCISE
docker-compose up --scale compute=3 --detach
sleep 60s
docker-compose down
rm -Rf $EXERCISE