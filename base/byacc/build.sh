pkgver=20230219
pkgname=byacc
deps="musl"
mkdeps="bmake"
bad=""
auto_cross

fetch() {
	curl -O "https://invisible-island.net/archives/byacc/byacc-$pkgver.tgz"
	tar -xf $pkgname-$pkgver.tgz
	# Merged upstream; Don't need
#	cp ../reader-mesa.patch .
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--program-prefix=b \
		--enable-btyacc \
		--build=$HOST_TRIPLE \
		--host=$TRIPLE
#	patch -p1 < ../reader-mesa.patch
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
