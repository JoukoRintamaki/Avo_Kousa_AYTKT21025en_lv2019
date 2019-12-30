#!/bin/bash
set -x
HEROKU_APP=jr-exercise-1-16
docker image pull --quiet devopsdockeruh/heroku-example
docker tag devopsdockeruh/heroku-example registry.heroku.com/$HEROKU_APP/web
docker push registry.heroku.com/$HEROKU_APP/web
heroku container:release web --app $HEROKU_APP

echo
echo
echo Public View:
echo
echo https://jr-exercise-1-16.herokuapp.com
echo
echo