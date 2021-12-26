pkgver=20210808
pkgname=byacc
deps=""
mkdeps="bmake"
bad=""

fetch() {
	curl https://invisible-island.net/datafiles/release/byacc.tar.gz -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	# Merged upstream; Don't need
#	cp ../reader-mesa.patch .
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--program-prefix=b \
		--enable-btyacc
#	patch -p1 < ../reader-mesa.patch
	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	ln -sr $pkgdir/usr/bin/byacc $pkgdir/usr/bin/yacc
}

backup() {

}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
