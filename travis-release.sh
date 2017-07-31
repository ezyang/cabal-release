#!/bin/sh
set -ex

. ./travis-common.sh

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    if [ "$ARCH" = "x86_64" ]; then
        sudo add-apt-repository -y ppa:hvr/ghc
        sudo apt-get update
        sudo apt-get install --force-yes ghc-$GHCVER cabal-install-$BOOTVER happy-1.19.5 alex-3.1.7
        cabal update
        ./travis-build.sh
    else
        sudo apt-get install --force-yes debootstrap schroot
        sudo mkdir -p /srv/chroot/trusty_i386
        sudo debootstrap --variant=buildd --arch=i386 trusty /srv/chroot/trusty_i386 http://archive.ubuntu.com/ubuntu/
        sudo cp /etc/apt/sources.list /srv/chroot/trusty_i386/etc/apt/
        sudo mkdir -p /srv/chroot/trusty_i386/srv/work
        sudo mount --bind $PWD /srv/chroot/trusty_i386/srv/work
        # Mounting /proc is important! See
        # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=787227
        sudo mount --bind /proc /srv/chroot/trusty_i386/proc
        sudo chroot /srv/chroot/trusty_i386 /srv/work/travis-chroot.sh
        sudo chown $USER cabal-install-*.gz
    fi
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

    cabal update
    cabal install -j2 happy alex

    ./travis-build.sh
else
    echo "Not linux or osx: $TRAVIS_OS_NAME"
    false
fi
