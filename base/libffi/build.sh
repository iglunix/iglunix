pkgver=3.4.4
pkgname=libffi
desc="A portable foreign-function interface library."
deps="musl"
bad="gmake"
ext="dev"
auto_cross

fetch() {
	curl -L "https://github.com/libffi/libffi/releases/download/v$pkgver/libffi-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
	# remove with libffi 3.4.5
	patch -p1 < ../../undef.patch
}

build() {
	cd $pkgname-$pkgver
	./configure --prefix=$PREFIX \
		--build=$HOST_TRIPLE \
		--host=$TRIPLE
	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
}

package_dev() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}

backup() {
	return
}
