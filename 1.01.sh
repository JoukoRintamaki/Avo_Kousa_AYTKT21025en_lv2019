#!/bin/bash
set -x
docker image pull --quiet nginx
docker run --detach --name nginx-01 nginx
docker run --detach --name nginx-02 nginx
docker run --detach --name nginx-03 nginx
docker ps --all
docker stop nginx-01 nginx-02
docker ps --all
docker rm nginx-01 nginx-02 nginx-03 --force --volumes