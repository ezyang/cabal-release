#!/bin/sh
set -ex
(cd cabal && cabal new-build -j2 cabal-install:cabal)
gzip cabal/dist-newstyle/build/$ARCH-$OS/ghc-$GHCVER/cabal-install-$VERSION/build/cabal/cabal -c > cabal-install-$VERSION-$ARCH-$OS.gz
