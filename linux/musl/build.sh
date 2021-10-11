pkgver=1.2.2
pkgname=musl
deps=""
mkdeps="gmake"
bad="gmake"
ext="dev"

fetch() {
	curl "https://musl.libc.org/releases/$pkgname-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
	cp ../../meson.build .
	cp ../../glob.sh .
	cp ../../globbits.sh .
	cp ../../version_h.sh .
	cp ../../crt.meson.build crt/meson.build
	mkdir bits
	cp ../../bits.meson.build bits/meson.build
	mkdir build
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. -Dprefix=/usr

	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install

	cd ..

	rm -rf $pkgdir/usr/include

	install -d $pkgdir/usr/bin
	install -d $pkgdir/lib

	mv $pkgdir/usr/lib/libc.so $pkgdir/lib/ld-musl-$(uname -m).so.1
	ln -sr $pkgdir/lib/ld-musl-$(uname -m).so.1 $pkgdir/usr/lib/libc.so
	ln -sr $pkgdir/lib/ld-musl-$(uname -m).so.1 $pkgdir/usr/bin/ldd
}

package_dev() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install

	rm $pkgdir/usr/lib/*.so
	rm -rf $pkgdir/lib
}

license() {
	cd $pkgname-$pkgver
	cat COPYRIGHT
}
