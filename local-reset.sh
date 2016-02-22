#!/usr/bin/env sh

rake db:drop && rake db:migrate && rake db:seed uiwebview native suite

