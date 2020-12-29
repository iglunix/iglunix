pkgver=6.8
pkgname=doas
pkgrel=1
bad=""
ext="doc"

fetch() {
	curl -L "https://github.com/Duncaen/OpenDoas/releases/download/v6.8/opendoas-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv opendoas-$pkgver $pkgname-$pkgver
	cp ../build.ninja $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	samu
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/bin
	install -Dm4755 $pkgdir/bin doas
}

package_doc() {
	cd $pkgname-$pkgver
	install -d $pkgdir/share/man/
	install -d $pkgdir/share/man/man1
	install -d $pkgdir/share/man/man5
	install -Dm644 $pkgdir/share/man/man1 doas.1
	install -Dm644 $pkgdir/share/man/man5 doas.conf.5
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
