#!/bin/sh

if [[ "$TRAVIS_BRANCH" != "master" ]]; then
    echo "Not deploying, only deploy for master branch"
    # analyze current branch and react accordingly
    exit 0
else
    chef exec bundle exec stove --username greysystems --key ./greysystems.pem --no-git
fi
