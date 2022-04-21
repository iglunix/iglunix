pkgver=6.7
pkgname=om4
pkgrel=1
deps="musl"
bad=""
ext="doc"
auto_cross

fetch() {
	curl -L "https://github.com/ibara/m4/releases/download/om4-6.7/om4-6.7.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
	patch -p1 < ../../m4-hand-written-lexer.patch
	patch -p1 < ../../configure.patch
}

build() {
	cd $pkgname-$pkgver
	./configure --prefix=/
	make -j1
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/bin
	install -Dm4755 om4 $pkgdir/usr/bin
	ln -sr $pkgdir/usr/bin/om4 $pkgdir/usr/bin/m4
}

package_doc() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/share/man/man1
	install -Dm644 m4.1 $pkgdir/usr/share/man/man1
}

license() {
	cd $pkgname-$pkgver
	echo "Source are a combination of BSD and ISC licensed files"
}

backup() {
	return
}
