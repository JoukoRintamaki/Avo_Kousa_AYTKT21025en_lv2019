FROM python
WORKDIR /usr/src/yle-dl
RUN apt-get -qq update &&     apt-get -qq install -y ffmpeg &&     mkdir -p /usr/src/yle-dl &&     pip3 install --upgrade yle-dl
ENTRYPOINT ["/usr/local/bin/yle-dl","--destdir","/usr/src/yle-dl"]
