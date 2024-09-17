#!/bin/zsh

BASEDIR=$(dirname $0)
cd $BASEDIR

git config core.commentChar ';'
git config core.hooksPath scripts/git/hooks

chmod -R +x ./git/hooks
