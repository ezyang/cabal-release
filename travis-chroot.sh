#!/bin/sh

set -ex

cd /srv/work

add-apt-repository -y ppa:hvr/ghc
apt-get update
apt-get install --force-yes ghc-$GHCVER cabal-install-$BOOTVER happy-1.19.5 alex-3.1.7
cabal update

./travis-build.sh
