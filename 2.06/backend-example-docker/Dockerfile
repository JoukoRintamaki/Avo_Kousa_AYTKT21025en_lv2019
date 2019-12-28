FROM node
ENV FRONT_URL=http://localhost:5000
WORKDIR /usr/src/backend-example-docker
RUN mkdir -p /usr/src/backend-example-docker
RUN git clone https://github.com/docker-hy/backend-example-docker /usr/src/backend-example-docker
RUN cd /usr/src/backend-example-docker && npm install
EXPOSE 8000
CMD ["npm","start"]
