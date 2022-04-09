pkgver=1.2.2
pkgname=musl
deps=""
mkdeps="gmake"
bad="gmake"
ext="dev"

fetch() {
	curl "https://musl.libc.org/releases/$pkgname-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	ln -s /usr/bin/cc $ARCH-linux-musl-cc
	cd $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver

	if [ -z "$FOR_CROSS" ]; then
		PREFIX=/usr
	else
		PREFIX=$FOR_CROSS_DIR
	fi


	CC=$(pwd)/../$ARCH-linux-musl-cc ./configure \
		--prefix=$PREFIX \
		--target=$TRIPLE

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake DESTDIR=$pkgdir install
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYRIGHT
}
