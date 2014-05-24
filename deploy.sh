#!/usr/bin/env sh

heroku maintenance:on

git push heroku master &&
heroku run 'rake db:migrate'

heroku maintenance:off
