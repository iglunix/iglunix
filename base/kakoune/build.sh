pkgver=2024.05.18
pkgname=kakoune
pkgrel=1
deps="musl:llvm"
bad=""
ext="doc"

fetch() {
	curl -LJ "https://github.com/mawww/kakoune/releases/download/v2024.05.18/kakoune-2024.05.18.tar.bz2" -o $pkgname-$pkgver.tar.xz 
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir PREFIX=/usr
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

backup() {
	return
}
