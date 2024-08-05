#!/bin/sh -e
# THIS MUST BE RUN FROM INSIDE THE CHECK BUILD CHROOT

cd "/build/$1"
iglupkg bp
