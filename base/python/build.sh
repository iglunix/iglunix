pkgname=python
pkgver=3.9.6
bad=""
ext="doc"

fetch() {
	curl "https://www.python.org/ftp/python/$pkgver/Python-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv Python-$pkgver $pkgname-$pkgver
}

build() {
    	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$TARGET \
		--host=$TARGET \
		--with-system-ffi=true \
		--with-ssl-default-suites=openssl \
		ax_cv_c_float_words_bigendian=no
	make
}

package() {
    	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/lib/python3.9/test
	rm -r $pkgdir/usr/lib/python3.9/ctypes/test
	rm -r $pkgdir/usr/lib/python3.9/distutils/tests
	rm -r $pkgdir/usr/lib/python3.9/idlelib/idle_test
	rm -r $pkgidr/usr/lib/python3.9/lib2to3/tests
	rm -r $pkgidr/usr/lib/python3.9/sqlite3/test
	rm -r $pkgdir/usr/lib/python3.9/tkinter/test
	rm -r $pkgdir/usr/lib/python3.9/unittest/test
	rm -r $pkgdir/usr/share
	ln -sr $pkgdir/usr/bin/python3 $pkgdir/usr/bin/python
}

package_doc() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -r $pkgdir/lib
	rm -r $pkgdir/bin
	rm -r $pkgdir/include
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
