pkgname=python
pkgver=3.12.0
mkdeps="libffi"
deps="musl"
desc="high-level scripting language"
bad=""
ext="doc"
auto_cross

fetch() {
	curl "https://www.python.org/ftp/python/$pkgver/Python-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv Python-$pkgver $pkgname-$pkgver
	cd $pkgname-$pkgver
	patch -p1 < ../../always-pip.patch
	cat >> Modules/Setup <<EOF
*disabled*
_uuid nis ossaudiodev
EOF

}

build() {
	cd $pkgname-$pkgver
	./configure \
		--build=$HOST_TRIPLE \
		--host=$TRIPLE  \
		--prefix=/usr \
		--enable-shared \
		--with-system-ffi=true \
		--with-ensurepip=yes \
		--with-ssl-default-suites=openssl
	make
}

backup() {
	return
}

package() {
    	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
	cd $pkgdir/usr/lib/python*
	rm -rf test ./*/test ./*/tests
	rm -rf idlelib turtle* config-*
	rm -rf $pkgdir/usr/share
	rm -f $pkgdir/usr/bin/idle*
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
