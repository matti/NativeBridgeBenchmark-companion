#!/usr/bin/env sh

git remote add heroku git@heroku.com:nativebridge-benchmark.git

heroku maintenance:on

git push heroku master &&
heroku run 'rake db:migrate'

heroku maintenance:off
