#!/bin/sh
printf '#define VERSION "%s"\n' $(sh ./tools/version.sh)
