#!/usr/bin/env bash

rm latest.dump


heroku pg:backups capture -a $1
curl -o latest.dump `heroku pg:backups public-url -a $1`

pg_restore --verbose --clean --no-acl --no-owner -h localhost -d nativebridge latest.dump
