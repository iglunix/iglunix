#!/bin/sh -ex
REPO_VER=$(curl -A "Iglunix Package Updater" -L "https://repology.org/api/v1/project/$2" | jq '[.[] | select(.status=="newest")][0].version' | cut -d'"' -f2)
TMP=$(mktemp)
sed 's/pkgver=.*/pkgver='$REPO_VER'/' $1/$2/build.sh > $TMP
mv $TMP $1/$2/build.sh
