pkgver=20220128
pkgname=byacc
deps="musl"
mkdeps="bmake"
bad=""
auto_cross

fetch() {
	curl "ftp://ftp.invisible-island.net/byacc/byacc-$pkgver.tgz" -O
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
