pkgname=gettext-tiny
pkgver=master
mkdeps="kati"
deps=""

fetch() {
	curl -L "https://github.com/sabotage-linux/gettext-tiny/archive/master.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	ckati
}

package() {
	cd $pkgname-$pkgver
	ckati install DESTDIR=$pkgdir prefix=/usr
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
