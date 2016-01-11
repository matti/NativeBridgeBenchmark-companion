heroku pg:reset postgresql-dimensional-6583 --confirm nativebridge-benchmark
heroku pg:reset DATABASE_URL --confirm nativebridge-benchmark

heroku run "rake db:migrate"

