#!/bin/dash
export MAKEFLAGS="-j6"
export CC=clang
export CXX=clang++

. ./build.sh
dir=$(pwd)
mkdir -p src
cd src
srcdir=$(pwd)

fetch
cd $srcdir

build
cd $srcdir

echo "
. $dir/build.sh
mkdir -p $dir/out/$pkgname
pkgdir=$dir/out/$pkgname package


mkdir -p $dir/out/$pkgname/lib/lazypkg

cat > $dir/out/$pkgname/lib/lazypkg/$pkgname << EOF
[pkg]
name=$pkgname
ver=$pkgver

[license]
EOF

chmod 644 $dir/out/$pkgname/lib/lazypkg/$pkgname
cd $srcdir
license >> $dir/out/$pkgname/lib/lazypkg/$pkgname

echo >> $dir/out/$pkgname/lib/lazypkg/$pkgname
echo [fs] >> $dir/out/$pkgname/lib/lazypkg/$pkgname

cd $dir/out/$pkgname/
find * >> $dir/out/$pkgname/lib/lazypkg/$pkgname

cd $dir/out/$pkgname
tar -cJf ../$pkgname.$pkgver.tar.xz *

echo $ext | tr ':' '\n' | while read e; do
	echo \$e

    cd $srcdir
    mkdir -p $dir/out/$pkgname-\$e
    pkgdir=$dir/out/$pkgname-\$e

    package_\$(echo \$e | tr '-' '_')

    mkdir -p $dir/out/$pkgname-\$e/lib/lazypkg

    cat > $dir/out/$pkgname-\$e/lib/lazypkg/$pkgname-\$e << EOF
[pkg]
name=$pkgname-\$e
ver=$pkgver

[license]
EOF

    chmod 644 $dir/out/$pkgname-\$e/lib/lazypkg/$pkgname-\$e
    cd $srcdir
    license >> $dir/out/$pkgname-\$e/lib/lazypkg/$pkgname-\$e

    echo >> $dir/out/$pkgname-\$e/lib/lazypkg/$pkgname-\$e
    echo [fs] >> $dir/out/$pkgname-\$e/lib/lazypkg/$pkgname-\$e

    cd $dir/out/$pkgname-\$e

	find * >> $dir/out/$pkgname-\$e/lib/lazypkg/$pkgname-\$e

    cd $dir/out/$pkgname-\$e
    tar -cJf ../$pkgname-\$e.$pkgver.tar.xz *

done


" | fakeroot sh
cd $dir
