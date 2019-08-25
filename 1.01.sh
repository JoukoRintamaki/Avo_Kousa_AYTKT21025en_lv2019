#!/bin/bash
set -x
docker run --detach --name nginx-01 nginx | cat
docker run --detach --name nginx-02 nginx | cat
docker run --detach --name nginx-03 nginx | cat
docker ps -a
docker stop nginx-01
docker stop nginx-02
docker ps -a
