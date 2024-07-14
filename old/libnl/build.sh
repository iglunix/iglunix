pkgname=libnl
pkgver=3.5.0

ifetch() {
	curl -L "https://github.com/thom311/libnl/releases/download/libnl3_5_0/libnl-3.5.0.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cp ../byacc-p-makefile.patch .
	cp ../byacc-syntax.patch .
	cp ../byacc-comment-defines.patch .
	cd $pkgname-$pkgver
	patch -p1 < ../byacc-syntax.patch

	echo "###############################"
	echo "#           WARNING           #"
	echo "# THIS IS PROBABLY NOT SECURE #"
	echo "###############################"

}

build() {
	cd $pkgname-$pkgver
	YACC=byacc ./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl

	patch -p1 < ../byacc-p-makefile.patch

	bad --gmake gmake

	patch -p1 < ../byacc-comment-defines.patch

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
