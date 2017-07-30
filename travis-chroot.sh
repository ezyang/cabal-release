#!/bin/sh

set -ex

cd /srv/work

source ./travis-common.sh

apt-get install -y --force-yes software-properties-common # for add-apt-repository
add-apt-repository -y ppa:hvr/ghc
apt-get update
apt-get install -y --force-yes ghc-$GHCVER cabal-install-$BOOTVER happy-1.19.5 alex-3.1.7
cabal update

./travis-build.sh
