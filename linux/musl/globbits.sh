#!/bin/sh
ARCH=$1

ARCH_INC=arch/$ARCH/bits/*.h
echo $ARCH_INC | tr ' ' '\n'

HAVE=$(echo $ARCH_INC | tr ' ' '\n' | sed 's|'$ARCH'|generic|g')

INCLUDES=arch/generic/bits/*.h
for inc in $HAVE; do
    INCLUDES=$(echo $INCLUDES | tr ' ' '\n' | grep -v $inc)
done
echo $INCLUDES | tr ' ' '\n'
