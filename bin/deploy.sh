#!/bin/bash
set -ux

getopts "npm" npm
getopts "db" db

# change branch to master
trap 'git checkout master && git branch -D release' EXIT

# change branch to release
git checkout master && git checkout -b release

# build assets
if [[ $npm != "?" ]]; then
  npm run build
fi

# migrate db
if [[ $db != "?" ]]; then
  heroku run rails db:migrate
fi

# push to release branch
git add .
git commit -m "Deploying to Heroku"

# deploy to heroku
git push heroku release:master --force
