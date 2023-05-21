#!/bin/sh
RR=$(realpath $(dirname "$0")/..)
CV=$RR/scripts/repover.sh

#printf -- '---\n'
#printf 'title: Out of date packages %s\n' "$(date -I)"
#printf -- '---\n'


# gmake is not the upstream package name
# $CV bad gmake 2>/dev/null

$CV linux musl 2>/dev/null
$CV linux busybox 2>/dev/null
$CV base bmake 2>/dev/null
$CV base byacc 2>/dev/null
$CV base cmake 2>/dev/null
$CV base curl 2>/dev/null
$CV base dhcpcd 2>/dev/null
# doas has two seperate repos with different version schemes
# $CV base doas 2>/dev/null

# flex repover is not right
# $CV base flex 2>/dev/null

$CV base git 2>/dev/null

# uses branch name
# $CV base iglunix 2>/dev/null
# $CV base iglupkg 2>/dev/null
# $CV base init 2>/dev/null
# $CV base installer 2>/dev/null
# $CV base kakoune 2>/dev/null

# part of LLVM stuff; versions should be synchronised
# $CV base libcxx 2>/dev/null

$CV base libffi 2>/dev/null

# part of LLVM stuff; versions should be synchronised
# $CV base libunwind 2>/dev/null

# We can't auto update LLVM; we need to keep it in sync with libcxx, libunwind, and compiler-rt
# $CV base llvm 2>/dev/null

# upstream version name is not numeric
# $CV base man-pages-posix 2>/dev/null

# mksh versions are not integers
# $CV base mksh 2>/dev/null

# uses branch name
# $CV base netbsd-curses 2>/dev/null
# $CV base om4 2>/dev/null

# non numeric name
# $CV base openssh 2>/dev/null
$CV base openssl 2>/dev/null

# uses branch name
# $CV base oslo 2>/dev/null
$CV base perl 2>/dev/null
$CV base pkgconf 2>/dev/null
$CV base samurai 2>/dev/null
$CV base toybox 2>/dev/null
$CV base zlib-ng 2>/dev/null

# uses branch name
# $CV base 🦆 2>/dev/null

$CV base mandoc 2>/dev/null

$CV gui libudev-zero 2>/dev/null
