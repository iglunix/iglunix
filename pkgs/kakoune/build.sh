pkgver=builtin-terminal-ui
pkgname=kakoune
pkgrel=1
bad=""
ext="doc"

fetch() {
	curl -L "https://github.com/mawww/kakoune/archive/builtin-terminal-ui.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	cd src
	ckati
}

package() {
	cd $pkgname-$pkgver
	cd src
	ckati install DESTDIR=$pkgdir PREFIX=/
	rm -r $pkgdir/share/doc
	rm -r $pkgdir/share/man
	rm -r $pkgdir/libexec
}

package_doc() {
	cd $pkgname-$pkgver
	cd src
	ckati install DESTDIR=$pkgdir PREFIX=/
	rm -r $pkgdir/share/kak
	rm -r $pkgdir/libexec
	rm -r $pkgdir/bin
}

license() {
	cd $pkgname-$pkgver
	cat UNLICENSE
}
