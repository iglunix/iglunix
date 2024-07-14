pkgver=0.0.1
pkgname=om4
pkgrel=1
mkdeps="bmake:byacc"
deps="musl"
bad=""
ext="doc"
auto_cross

iifetch() {
	curl -L "https://github.com/iglunix/om4/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cd $pkgname-$pkgver
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
	ln -s om4 $pkgdir/usr/bin/m4
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
