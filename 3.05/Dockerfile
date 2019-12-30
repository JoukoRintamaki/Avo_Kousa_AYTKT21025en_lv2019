FROM node as build
WORKDIR /usr/src/frontend-example-docker
RUN mkdir -p /usr/src/frontend-example-docker && git clone https://github.com/docker-hy/frontend-example-docker.git /usr/src/frontend-example-docker && cd /usr/src/frontend-example-docker && npm install

FROM node:alpine
WORKDIR /frontend-example-docker
COPY --from=build /usr/src/frontend-example-docker /frontend-example-docker
EXPOSE 5000
CMD ["npm","start"]
