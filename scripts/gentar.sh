#!/bin/sh

. ./build_utils

packages=(musl mksh bmake gmake llvm libressl mandoc cmake curl reflex byacc om4 zlib samurai libffi python ca-certificates zlib expat gettext-tiny git kati netbsd-curses kakoune iglunix rust toybox busybox less pci-ids libexecinfo)
cp_packages $(pwd)/_pi_install
