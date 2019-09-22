FROM ruby:2.6.0
WORKDIR /usr/src/rails-example-project
RUN mkdir -p /usr/src/rails-example-project
RUN git clone https://github.com/docker-hy/rails-example-project.git /usr/src/rails-example-project 
RUN cd /usr/src/rails-example-project && bundle install && rails db:migrate RAILS_ENV=production && rake assets:precompile 
EXPOSE 3000
CMD ["rails ","s","-e"."production"]
