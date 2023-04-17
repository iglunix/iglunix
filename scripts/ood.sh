#!/bin/sh
RR=$(realpath $(dirname "$0")/..)
CV=$RR/scripts/repover.sh

#printf -- '---\n'
#printf 'title: Out of date packages %s\n' "$(date -I)"
#printf -- '---\n'

$CV base bmake 2>/dev/null
$CV base byacc 2>/dev/null
$CV base dhcpcd 2>/dev/null
$CV base openssl 2>/dev/null

# We can't auto update LLVM; we need to keep it in sync with libcxx, libunwind, and compiler-rt
# $CV base llvm 2>/dev/null
