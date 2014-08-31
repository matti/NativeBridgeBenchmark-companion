#!/bin/sh

if [ "$1" == "all" ]; then
	git pull
	bundle install
	rake db:migrate

	atom . &
fi

rails s &
sleep 3
open "http://localhost:3000/tests" &

guard
