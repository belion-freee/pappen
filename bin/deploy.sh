#!/bin/bash
set -ux

# change branch to master
trap 'git checkout master' EXIT

# change branch to release
git checkout release

# merge master to release branch
git merge master -m "Merge master to release branch"

# exec cmd before deploy to heroku
npm run build

# push to release branch
git add .
git commit -m "Deploying to Heroku"
git push origin release

# deploy to heroku
git push heroku release:master
