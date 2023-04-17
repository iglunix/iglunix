#!/bin/sh
RR=$(realpath $(dirname "$0")/..)
CV=$RR/scripts/repover.sh

#printf -- '---\n'
#printf 'title: Out of date packages %s\n' "$(date -I)"
#printf -- '---\n'


# gmake is not the upstream package name
# $CV bad gmake 2>/dev/null

# mksh versions are not integers
# $CV base mksh 2>/dev/null

# flex repover is not right
# $CV base flex 2>/dev/null

$CV linux musl 2>/dev/null
$CV linux toybox 2>/dev/null
$CV linux busybox 2>/dev/null
$CV base bmake 2>/dev/null
$CV base byacc 2>/dev/null
$CV base dhcpcd 2>/dev/null
$CV base openssl 2>/dev/null

# We can't auto update LLVM; we need to keep it in sync with libcxx, libunwind, and compiler-rt
# $CV base llvm 2>/dev/null
