#!/bin/sh
cd /etc/ssl && {
	curl -LO https://curl.haxx.se/ca/cacert.pem -o /etc/ssl/certs/ca-certificates.crt
}
