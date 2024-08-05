#!/bin/sh


DIR=$(realpath $(dirname $0)/..)
echo $DIR
cd $DIR

function install_pkg {
    echo Installing $2
    cd $DIR/$1/$2/
    stat $DIR/$1/$2/out/*.tar.* > /dev/null 2> /dev/null && echo "Already built $2"
    stat $DIR/$1/$2/out/*.tar.* > /dev/null 2> /dev/null || iglupkg

    stat $DIR/out/usr/share/iglupkg/$2 > /dev/null 2> /dev/null && echo "Already installed $2"
    stat $DIR/out/usr/share/iglupkg/$2 > /dev/null 2> /dev/null || tar -C $DIR/out -xf $DIR/$1/$2/out/$2.*.tar.zst -I zstd

    stat $DIR/$1/$2/out/$2-dev.tar.zst > /dev/null 2> /dev/null || return
    stat $DIR/out/usr/share/iglupkg/$2-dev > /dev/null 2> /dev/null && echo "Already installed $2-dev"
    stat $DIR/out/usr/share/iglupkg/$2-dev > /dev/null 2> /dev/null || tar -C $DIR/out -xf $DIR/$1/$2/out/$2-dev.*.tar.zst -I zstd
    
    cd $DIR
}

# install_pkg linux raspberrypi-linux
install_pkg linux raspberrypi-firmware
install_pkg linux linux-firmware
install_pkg linux make_ext4fs
install_pkg linux musl
install_pkg linux busybox

install_pkg base bmake
install_pkg base byacc
install_pkg base ca-certificates
install_pkg base cmake
install_pkg base curl
install_pkg base expat
install_pkg base fakeroot
install_pkg base gettext-tiny
install_pkg base git
install_pkg base go
install_pkg base iglunix
install_pkg base kakoune
install_pkg base kati
install_pkg base lc-make
install_pkg base libexecinfo
install_pkg base libffi
install_pkg base libnl-tiny
install_pkg base llvm
install_pkg base meson
install_pkg base mksh
install_pkg base netbsd-curses
install_pkg base om4
install_pkg base openpam
install_pkg base openssh
install_pkg base openssl
install_pkg base pci-ids
install_pkg base pfetch
install_pkg base pkgconf
install_pkg base python
install_pkg base python-mako
install_pkg base python-setuptools
install_pkg base flex
install_pkg base rust
install_pkg base samurai
install_pkg base toybox
install_pkg base wpa_supplicant
install_pkg base zig
install_pkg base zlib-ng
install_pkg base zstd

exit 1

function install

linux/raspberrypi-linux
linux/raspberrypi-firmware
linux/busybox

base/bmake
base/byacc
base/ca-certificates
base/cmake
base/curl
base/expat
base/gettext-tiny
base/git
base/go
base/iglunix
base/kakoune
base/kati
base/lc-make
base/libexecinfo
base/libffi
base/libnl-tiny
base/llvm
base/meson
base/mksh
base/netbsd-curses
base/om4
base/openpam
base/openssl
base/pci-ids
base/pfetch
base/pkgconf
base/python
base/python-mako
base/python-setuptools
base/reflex
base/rust
base/samurai
base/toybox
base/wpa_supplicant
base/zig
base/zlib-ng
base/zstd
