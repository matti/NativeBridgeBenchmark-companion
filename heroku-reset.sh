heroku pg:reset postgresql-dimensional-6583 --confirm nativebridge-benchmark
heroku run "rake db:migrate"

