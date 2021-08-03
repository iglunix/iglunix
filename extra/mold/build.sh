pkgname=mold
pkgver=main
deps="musl:libexecinfo"

fetch() {
	curl -L "https://github.com/rui314/mold/archive/refs/heads/main.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
	patch -p1 < ../../musl.patch
}

build() {
	cd $pkgname-$pkgver
	gmake
}

package() {
	cd $pkgname-$pkgver
	gmake install DESTDIR=$pkgdir
	ln -sr $pkgdir/usr/bin/mold $pkgdir/usr/bin/ld.mold
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
