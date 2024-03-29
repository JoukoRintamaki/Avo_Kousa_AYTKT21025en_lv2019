#!/bin/bash
set -x

EXERCISE=1.17
TAG=jradoptopenjdk

mkdir -p $EXERCISE

cat > $EXERCISE/Dockerfile <<'EOF'
FROM ubuntu
RUN apt-get -qq update && apt-get -qq install wget
RUN mkdir -p /opt; \
    cd /opt; \
    wget https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.5%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.5_10.tar.gz
RUN cd /opt; tar xzf OpenJDK11U-jdk_x64_linux_hotspot_11.0.5_10.tar.gz
RUN cd /opt; ln -s jdk-11.0.5+10 java
RUN rm -f /opt/OpenJDK11U-jdk_x64_linux_hotspot_11.0.5_10.tar.gz
ENV JAVA_HOME=/opt/java
ENV PATH="$PATH:$JAVA_HOME/bin"
EOF

docker build --quiet --tag $TAG $EXERCISE 
docker run --name $TAG $TAG

docker tag $TAG joukorintamaki/$TAG
docker push joukorintamaki/$TAG

set +x

echo
echo
echo Public View:
echo
echo https://hub.docker.com/r/joukorintamaki/jradoptopenjdk
echo
echo Description:
echo Ubuntu + Adopt OpenJdk Ready to use development environment
echo

docker rm $TAG --force --volumes