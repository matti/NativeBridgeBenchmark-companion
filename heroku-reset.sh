heroku pg:reset postgresql-dimensional-6583 --confirm nativebridge-benchmark --app nativebridge-benchmark
heroku run "rake db:migrate" --app nativebridge-benchmark

