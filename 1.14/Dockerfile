FROM ruby:2.6.0
WORKDIR /usr/src/rails-example-project
RUN mkdir -p /usr/src/rails-example-project
RUN git clone https://github.com/docker-hy/rails-example-project.git /usr/src/rails-example-project 
RUN cd /usr/src/rails-example-project && bundle install
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN rails db:migrate
RUN rake assets:precompile
EXPOSE 3000
CMD ["rails","s"]
