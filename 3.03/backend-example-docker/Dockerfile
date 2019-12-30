FROM node:alpine
ENV FRONT_URL=http://localhost
RUN apk add --no-cache git &&  mkdir -p /usr/src/backend-example-docker &&  git clone https://github.com/docker-hy/backend-example-docker /usr/src/backend-example-docker &&  cd /usr/src/backend-example-docker &&  npm install &&  apk del git &&  addgroup -S appgroup && adduser -S appuser -G appgroup &&  chown --recursive appuser /usr/src/backend-example-docker
USER appuser
WORKDIR /usr/src/backend-example-docker
EXPOSE 8000
CMD ["npm","start"]
