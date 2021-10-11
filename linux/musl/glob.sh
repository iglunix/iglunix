#!/bin/sh

ARCH=$1
MALLOC_IMPL=mallocng

ARCH_FILES=src/*/x86_64/*.[csS]

HAVE=$(echo $ARCH_FILES | tr ' ' '\n' | sed 's|'$ARCH/'||g' | cut -d'.' -f 1)
echo $ARCH_FILES | tr ' ' '\n'

FILES=$(echo src/*/*.[csS] | tr ' ' '\n')
for have in $HAVE; do
    FILES=$(echo $FILES | tr ' ' '\n' | grep -v $have'.[csS]')
done

echo $FILES | tr ' ' '\n'

echo src/malloc/$MALLOC_IMPL/*.[csS] | tr ' ' '\n'

#find src/*/ -maxdepth 1 -name '*.[csS]'

#find src/*/$ARCH -maxdepth 1 -name '*.[csS]'

