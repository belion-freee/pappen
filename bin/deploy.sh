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
  echo "run npm build on local and create assets"
  npm run build
fi

# push to release branch
git add .
git commit -m "Deploying to Heroku"

# deploy to heroku
git push heroku release:master --force

# migrate db
if [[ $db != "?" ]]; then
  echo "run rails db:migrate on heroku"
  heroku run rails db:migrate
fi
