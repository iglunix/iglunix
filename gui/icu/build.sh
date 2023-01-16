pkgname=icu
pkgver=72.1

_pkg_ver=$(echo $pkgver | tr '.' '_')

fetch() {
	curl -L "https://github.com/unicode-org/icu/releases/download/release-72-1/icu4c-$_pkg_ver-src.tgz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv $pkgname $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver

	cd source
	./configure \
		--prefix=/usr \
		--build=$TRIPLE \
		--host=$TRIPLE

	bad --gmake gmake
}

backup() {
	return
}

package() {
	cd $pkgname-$pkgver
	cd source
	bad --gmake gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
