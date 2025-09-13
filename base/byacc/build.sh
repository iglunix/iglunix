pkgver=20240109
pkgname=byacc
deps="musl"
mkdeps="bmake"
bad=""

fetch() {
	curl -O "https://invisible-island.net/archives/byacc/byacc-$pkgver.tgz"
	tar -xf $pkgname-$pkgver.tgz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--program-prefix=b \
		--enable-btyacc \
		--build=$HOST_TRIPLE \
		--host=$TRIPLE
	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	ln -s byacc $pkgdir/usr/bin/yacc
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
