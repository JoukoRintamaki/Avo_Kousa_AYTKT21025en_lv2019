FROM openjdk:8 
WORKDIR /usr/src/spring-example-project
RUN mkdir -p /usr/src/spring-example-project
RUN git clone https://github.com/docker-hy/spring-example-project /usr/src/spring-example-project 
RUN cd /usr/src/spring-example-project && ./mvnw package 
EXPOSE 8080
CMD ["java","-jar","./target/docker-example-1.1.3.jar"]
