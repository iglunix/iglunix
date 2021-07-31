#!/bin/sh

. ./build_utils
packages=(musl mksh bmake gmake llvm libressl cmake curl rsync flex byacc om4 zlib samurai libffi python ca-certificates expat gettext-tiny git kati netbsd-curses kakoune iglunix rust toybox busybox less pci-ids heirloom-doctools)
cp_packages /mnt
