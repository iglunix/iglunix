pkgname=icu
pkgver=69.1

_pkg_ver=$(echo $pkgver | tr '.' '_')

fetch() {
	curl -L "https://github.com/unicode-org/icu/releases/download/release-69-1/icu4c-$_pkg_ver-src.tgz" -o $pkgname-$pkgver.tar.xz
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

	gmake
}

package() {
	cd $pkgname-$pkgver
	cd source
	gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
