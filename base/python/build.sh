pkgname=python
pkgver=3.10.4
bad=""
ext="doc"
auto_cross

fetch() {
	curl "https://www.python.org/ftp/python/$pkgver/Python-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv Python-$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=$HOST_TRIPLE \
		--host=$HOST_TRIPLE  \
		--with-system-ffi=true \
		--with-ssl-default-suites=openssl \
		--without-ensure-pip \
		ax_cv_c_float_words_bigendian=no \
		ac_cv_buggy_getaddrinfo=no \
		ac_cv_file__dev_ptmx=yes \
		ac_cv_file__dev_ptc=no
	make
}

package() {
    	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/lib/python3.10/test
	rm -r $pkgdir/usr/lib/python3.10/ctypes/test
	rm -r $pkgdir/usr/lib/python3.10/distutils/tests
	rm -r $pkgdir/usr/lib/python3.10/idlelib/idle_test
	rm -r $pkgidr/usr/lib/python3.10/lib2to3/tests
	rm -r $pkgidr/usr/lib/python3.10/sqlite3/test
	rm -r $pkgdir/usr/lib/python3.10/tkinter/test
	rm -r $pkgdir/usr/lib/python3.10/unittest/test
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
