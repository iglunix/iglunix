pkgname=python
pkgver=3.11.3
mkdeps="libffi"
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
		--host=$TRIPLE  \
		--with-system-ffi=true \
		--with-ssl-default-suites=openssl \
		--without-ensure-pip \
		ax_cv_c_float_words_bigendian=no \
		ac_cv_buggy_getaddrinfo=no \
		ac_cv_file__dev_ptmx=yes \
		ac_cv_file__dev_ptc=no
	make
}

backup() {
	return
}

package() {
    	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/lib/python*/test
	rm -r $pkgdir/usr/lib/python*/ctypes/test
	rm -r $pkgdir/usr/lib/python*/distutils/tests
	rm -r $pkgdir/usr/lib/python*/idlelib/idle_test
	rm -r $pkgdir/usr/lib/python*/lib2to3/tests
	#rm -r $pkgidr/usr/lib/python*/sqlite3/test
	rm -r $pkgdir/usr/lib/python*/tkinter/test
	rm -r $pkgdir/usr/lib/python*/unittest/test
	rm -r $pkgdir/usr/share
	ln -s python3 $pkgdir/usr/bin/python
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
