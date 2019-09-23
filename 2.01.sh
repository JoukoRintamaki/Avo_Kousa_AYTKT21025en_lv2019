#!/bin/bash
set -x
rm -f /c/Temp/logs.txt
touch /c/Temp/logs.txt
EXERCISE=2.01
TAG=first_volume_exercise
EXERCISEFOLDER=$EXERCISE.$TAG

if [[ ! -e $EXERCISEFOLDER/docker-compose.yml ]]; then
	mkdir -p $EXERCISEFOLDER
	touch $EXERCISEFOLDER/docker-compose.yml
fi

cat >$EXERCISEFOLDER/docker-compose.yml <<EOF
version: "3"
services:
      $TAG:
            image: devopsdockeruh/$TAG
            volumes:
                  - /c/Temp/logs.txt:/usr/app/logs.txt
EOF

cat /c/Temp/logs.txt
cd $EXERCISEFOLDER && timeout 10s docker-compose up
cat /c/Temp/logs.txt