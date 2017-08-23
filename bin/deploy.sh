#!/bin/bash
set -ex

# change branch to release
git checkout release

# merge master to release branch
git merge master

# exec cmd before deploy to heroku
npm run build

# push to release branch
git add .
git commit -m "Deploying to Heroku"
git push origin release

# deploy to heroku
git push heroku release:master

function finally {
  # change branch to master
  git checkout master
}
