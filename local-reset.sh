#!/usr/bin/env sh

rake db:drop && rake db:migrate && rake db:seed $1 $2 $3

