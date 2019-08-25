#!/bin/bash
set -x
docker run --detach --name nginx-01 nginx
docker run --detach --name nginx-02 nginx
docker run --detach --name nginx-03 nginx
docker ps -a
docker stop nginx-01
docker stop nginx-02
docker ps -a
