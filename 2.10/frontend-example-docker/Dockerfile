FROM node
ENV API_URL=http://localhost:8000
WORKDIR /usr/src/frontend-example-docker
RUN mkdir -p /usr/src/frontend-example-docker
RUN git clone https://github.com/docker-hy/frontend-example-docker /usr/src/frontend-example-docker
RUN cd /usr/src/frontend-example-docker && npm install
EXPOSE 5000
CMD ["npm","start"]
