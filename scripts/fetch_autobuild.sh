#!/bin/sh -e

URL=$(curl -s 'https://api.github.com/repos/iglunix/iglunix-autobuild/actions/artifacts' \
| jq '.artifacts | [ .[] | select(.name == "packages") ] | .[0].archive_download_url')

URL=${URL##\"}
URL=${URL%%\"}

printf "Fetching zip from %s\n" $URL

curl -LO -H "Authorization: Bearer $GITHUB_TOKEN" "$URL"

unzip zip
