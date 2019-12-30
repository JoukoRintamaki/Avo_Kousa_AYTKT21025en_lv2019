FROM node:alpine
ENV API_URL=http://localhost:8000
RUN apk add --no-cache git &&  mkdir -p /usr/src/frontend-example-docker &&  git clone https://github.com/docker-hy/frontend-example-docker /usr/src/frontend-example-docker &&  cd /usr/src/frontend-example-docker &&  npm install &&  apk del git &&  addgroup -S appgroup && adduser -S appuser -G appgroup &&  chown --recursive appuser /usr/src/frontend-example-docker
USER appuser
WORKDIR /usr/src/frontend-example-docker
EXPOSE 5000
CMD ["npm","start"]
