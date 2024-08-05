#!/bin/sh -e

mkdir -p xbps-crap
cd xbps-crap
curl -LO https://repo-fastly.voidlinux.org/static/xbps-static-static-0.59.1_6.x86_64-musl.tar.xz
tar -xf xbps-static-static-0.59.1_6.x86_64-musl.tar.xz
sudo cp usr/bin/xbps-* /usr/bin
cd ..
