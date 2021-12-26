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
	./configure --prefix=/usr \
	--without-pam
	gmake
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/bin
	install -Dm4755 doas $pkgdir/usr/bin
}

package_doc() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/share/man/
	install -d $pkgdir/usr/share/man/man1
	install -d $pkgdir/usr/share/man/man5
	install -Dm644 doas.1 $pkgdir/usr/share/man/man1
	install -Dm644 doas.conf.5 $pkgdir/usr/share/man/man5
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
