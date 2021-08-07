#!/bin/sh
REPO_VER=$(curl "https://repology.org/project/$1/history" 2>/dev/null | grep "version-newest" | tr '>' ' ' | tr '<' ' ' | awk '{ print $5; }' | head -n1)

REPO_MAJOR=$(echo $REPO_VER | tr '.' ' ' | awk '{ print $1; }')
REPO_MINOR=$(echo $REPO_VER | tr '.' ' ' | awk '{ print $2; }')
REPO_MICRO=$(echo $REPO_VER | tr '.' ' ' | awk '{ print $3; }')

LOCAL_VER=$(cat */$1/build.sh | grep 'pkgver=' | tr '=' ' ' | awk '{ print $2; }')

LOCAL_MAJOR=$(echo $LOCAL_VER | tr '.' ' ' | awk '{ print $1; }')
LOCAL_MINOR=$(echo $LOCAL_VER | tr '.' ' ' | awk '{ print $2; }')
LOCAL_MICRO=$(echo $LOCAL_VER | tr '.' ' ' | awk '{ print $3; }')

echo "Remote Version:" $REPO_VER >&2
echo "Local Version:" $LOCAL_VER >&2
echo $REPO_VER
