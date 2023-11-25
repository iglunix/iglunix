pkgver=2.1.0
pkgname=pkgconf
bad=""
ext="doc"
mkdeps="bmake"
deps="musl"
desc="Package compiler and linker metadata toolkit"

fetch() {
	curl https://distfiles.dereferenced.org/pkgconf/pkgconf-$pkgver.tar.xz -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr
	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	ln -s pkgconf $pkgdir/usr/bin/pkg-config
	rm -r $pkgdir/usr/share
}

package_doc() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/bin
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}

backup() {
	return
}
