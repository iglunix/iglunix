pkgname=hwdata
pkgver=0.376
mkdeps="bad:gmake"

fetch() {
	curl -L "https://github.com/vcrhonek/hwdata/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--disable-blacklist

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}

backup() {
	return
}
