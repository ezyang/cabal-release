#!/bin/sh
set -ex

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    sudo add-apt-repository -y ppa:hvr/ghc
    sudo apt-get update
    sudo apt-get install --force-yes ghc-$GHCVER:$ARCH cabal-install-$BOOTVER:$ARCH
elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
    curl -OL http://downloads.haskell.org/~ghc/$GHCVER/ghc-${GHCVER}-x86_64-apple-darwin.tar.xz
    tar -xJf ghc-*.tar.xz
    cd ghc-*;
    ./configure --prefix=$HOME/.ghc-install/$GHCVER
    make install
    cd ..

    mkdir "${HOME}/bin"
    curl -L http://web.mit.edu/~ezyang/Public/cabal-install-2.0.0.0-osx.gz | gunzip -c > "${HOME}/bin/cabal"
    chmod a+x "${HOME}/bin/cabal"
else
    echo "Not linux or osx: $TRAVIS_OS_NAME"
    false
fi

which ghc
ghc --version

which cabal
cabal --version
