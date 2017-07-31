#!/bin/sh

set -ex

cd /srv/work

. ./travis-common.sh

apt-get install -y --force-yes software-properties-common # for add-apt-repository
add-apt-repository -y ppa:hvr/ghc
apt-get update
apt-get install -y --force-yes ghc-$GHCVER cabal-install-$BOOTVER happy-1.19.5 alex-3.1.7

# apt-get update
# attempted workaround from https://github.com/haskell/cabal/issues/3474
# apt-get install -y --force-yes ghc cabal-install happy alex libz-dev c2hs cpphs hscolour hugs
ghc --version
cabal --version
cabal update

(cd cabal/Cabal && cabal install)
(cd cabal/cabal-install && cabal install)
gzip $HOME/.cabal/bin/cabal -c > cabal-install-$VERSION-$ARCH-$OS.gz
