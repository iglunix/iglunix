pkgver=6.8
pkgname=doas
pkgrel=1
bad="gmake"
ext="doc"

fetch() {
	curl -L "https://github.com/Duncaen/OpenDoas/releases/download/v6.8/opendoas-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv opendoas-$pkgver $pkgname-$pkgver
	cp ../build.ninja $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	./configure --prefix=/
	gmake
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/bin
	install -Dm4755 doas $pkgdir/bin
}

package_doc() {
	cd $pkgname-$pkgver
	install -d $pkgdir/share/man/
	install -d $pkgdir/share/man/man1
	install -d $pkgdir/share/man/man5
	install -Dm644 doas.1 $pkgdir/share/man/man1
	install -Dm644 doas.conf.5 $pkgdir/share/man/man5
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
