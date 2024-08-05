pkgname=hwdata
pkgver=0.366

fetch() {
    curl -L "https://github.com/vcrhonek/hwdata/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
    tar -xf $pkgname-$pkgver.tar.xz
}

build() {
    cd $pkgname-$pkgver
    ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --build=$TRIPLE \
        --host=$TRIPLE

   patch Makefile ../../install_T_fix
   bad --gmake g make
}

backup() {
	return
}

package() {
    cd $pkgname-$pkgver
    bad --gmake gmake install DESTDIR=$pkgdir
}

license() {
    cd $pkgname-$pkgver
    cat LICENSE
#    cat COPYING
}

