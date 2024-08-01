#!/bin/zsh

set -Ceu

# 今のディレクトリ
# dotfilesディレクトリに移動する
BASEDIR=$(dirname $0)
cd $BASEDIR

if which mise >/dev/null; then
    echo "🚀mise is already installed."
else
    echo "🚀install mise"
    brew install mise
fi

mise i

