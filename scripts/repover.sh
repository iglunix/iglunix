#!/bin/sh
REPO_VER=$(curl "https://repology.org/project/$2/history" 2>/dev/null | grep "version-newest" | tr '>' ' ' | tr '<' ' ' | awk '{ print $5; }' | head -n1)

REPO_MAJOR=$(echo $REPO_VER | tr '.' ' ' | awk '{ print $1; }')
REPO_MINOR=$(echo $REPO_VER | tr '.' ' ' | awk '{ print $2; }')
REPO_MICRO=$(echo $REPO_VER | tr '.' ' ' | awk '{ print $3; }')

LOCAL_VER=$(cat $1/$2/build.sh | grep 'pkgver=' | tr '=' ' ' | awk '{ print $2; }')

LOCAL_MAJOR=$(echo $LOCAL_VER | tr '.' ' ' | awk '{ print $1; }')
LOCAL_MINOR=$(echo $LOCAL_VER | tr '.' ' ' | awk '{ print $2; }')
LOCAL_MICRO=$(echo $LOCAL_VER | tr '.' ' ' | awk '{ print $3; }')

printf 'Remote Version: %s.%s.%s\n' $REPO_MAJOR $REPO_MINOR $REPO_MICRO >&2
printf 'Local Version: %s.%s.%s\n' $LOCAL_MAJOR $LOCAL_MINOR $LOCAL_MICRO >&2

if [ -z "$REPO_MAJOR" ]
then
	REPO_MAJOR=0
fi

if [ -z "$REPO_MINOR" ]
then
	REPO_MINOR=0
fi

if [ -z "$REPO_MICRO" ]
then
	REPO_MICRO=0
fi

if [ -z "$LOCAL_MAJOR" ]
then
	LOCAL_MAJOR=0
fi

if [ -z "$LOCAL_MINOR" ]
then
	LOCAL_MINOR=0
fi

if [ -z "$LOCAL_MICRO" ]
then
	LOCAL_MICRO=0
fi

if [ "$REPO_MAJOR" -gt "$LOCAL_MAJOR" -o "$REPO_MINOR" -gt "$LOCAL_MINOR" -o "$REPO_MICRO" -gt "$LOCAL_MICRO" ]
then
	printf '\n'
	printf ' - [ ] Package `%s` is out of date!\n' "$1/$2"
	printf '       Remote Version: `%s.%s.%s`\n' $REPO_MAJOR $REPO_MINOR $REPO_MICRO
	printf '       Local Version: `%s.%s.%s`\n' $LOCAL_MAJOR $LOCAL_MINOR $LOCAL_MICRO
	printf '\n'
fi

# printf $REPO_VER
