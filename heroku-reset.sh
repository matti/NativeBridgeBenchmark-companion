#heroku pg:reset postgresql-dimensional-6583 --confirm nativebridge-benchmark --app nativebridge-benchmark
heroku pg:reset DATABASE_URL --confirm $1
heroku run "rake db:migrate" --app $1

heroku run rake db:seed $2 $3 $4 --app $1
