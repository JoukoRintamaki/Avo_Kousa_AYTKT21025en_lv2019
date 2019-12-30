#!/bin/bash
set -x
EXERCISE=3.06
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
docker image ls | grep $TAG
docker image rm $TAG

# apt clean, apt remove cache
# wget + tar one liner
# only one RUN
cat > $EXERCISE/Dockerfile <<'EOF'
FROM ubuntu
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get -qq update && apt-get install -qqy wget && apt-get -qq autoclean && apt-get -qq autoremove && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt \
    && wget -qc https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.5%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.5_10.tar.gz -O - | tar -xz -C /opt \
    && ln -s /opt/jdk-11.0.5+10 /opt/java \
    && apt-get purge -qqy wget && apt-get -qqy autoclean && apt-get -qqy autoremove    
ENV JAVA_HOME=/opt/java
ENV PATH="$PATH:$JAVA_HOME/bin"
EOF
docker build --quiet --tag $TAG $EXERCISE
docker image ls | grep $TAG
docker image rm $TAG