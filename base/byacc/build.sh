pkgver=20241231
pkgname=byacc
subpkgs=byacc
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
	mkdir -p $pkgdir/usr/bin
	cp yacc $pkgdir/usr/bin/byacc
	ln -s byacc $pkgdir/usr/bin/yacc
}

byacc() {
	find usr/bin
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
