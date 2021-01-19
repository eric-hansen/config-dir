#!/bin/sh

DIR=$(dirname $(readlink -f "$0"))
echo "[>>] Git dir: $DIR"

ln -s $DIR/config ~/.gitconfig
