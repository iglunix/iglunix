pkgver=master
pkgname=kakoune
pkgrel=1
deps="musl:llvm"
bad=""
ext="doc"

fetch() {
	curl -L "https://github.com/mawww/kakoune/archive/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	ckati
}

package() {
	cd $pkgname-$pkgver
	ckati install DESTDIR=$pkgdir PREFIX=/usr
	rm -r $pkgdir/usr/share/doc
	rm -r $pkgdir/usr/share/man
	rm -r $pkgdir/usr/libexec
}

package_doc() {
	cd $pkgname-$pkgver
	ckati install DESTDIR=$pkgdir PREFIX=/usr
	rm -r $pkgdir/usr/share/kak
	rm -r $pkgdir/usr/libexec
	rm -r $pkgdir/usr/bin
}

license() {
	cd $pkgname-$pkgver
	cat UNLICENSE
}
