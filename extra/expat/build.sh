pkgver=2.5.0
pkgname=expat
bad=""
mkdeps="bmake"
deps=""
ext="dev"
auto_cross

fetch() {
	pkgver_r=$(echo $pkgver | tr '.' '_')
	curl -L https://github.com/libexpat/libexpat/releases/download/R_$pkgver_r/$pkgname-$pkgver.tar.xz -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$HOST_TRIPLE \
		--host=$TRIPLE
	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}

backup() {
	return
}
