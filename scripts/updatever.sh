#!/bin/sh
NVER=$(curl "https://repology.org/project/$2/history" 2>/dev/null | grep "version-newest" | tr '>' ' ' | tr '<' ' ' | awk '{ print $5; }' | head -n1)
TMP=$(mktemp)
sed 's/pkgver=.*/pkgver='$NVER'/' $1/$2/build.sh > $TMP
mv $TMP $1/$2/build.sh
