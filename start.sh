#!/bin/sh
atom . &

rails s &
sleep 3
open "http://localhost:3000/tests" &

guard
