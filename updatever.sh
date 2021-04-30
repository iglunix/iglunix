#!/bin/sh
NVER=$(./repover.sh $1)
TMP=$(mktemp)
sed 's/pkgver=.*/pkgver='$NVER'/g' pkgs/$1/build.sh > $TMP
mv $TMP pkgs/$1/build.sh
