FROM node
WORKDIR /usr/src/backend-example-docker
RUN mkdir -p /usr/src/backend-example-docker && git clone https://github.com/docker-hy/backend-example-docker /usr/src/backend-example-docker && cd /usr/src/backend-example-docker && npm install
EXPOSE 8000
CMD ["npm","start"]
