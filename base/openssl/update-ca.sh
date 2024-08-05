#!/bin/sh -e

if [ ! "$(id -u)" -eq 0 ]
then
	printf 'ERROR: must be run as root\n'
	exit 1
fi

if [ ! -d /etc/ssl ]
then
	printf 'ensuring directory for certs\n'
	mkdir -p /etc/ssl
fi

extra_args=
if [ ! -e /etc/ssl/cert.pem ]
then
	printf 'WARNING: using insecure protocol for downloading certificates\n'
	extra_args=-k
fi
curl $extra_args -L https://curl.haxx.se/ca/cacert.pem -o /etc/ssl/cert.pem
