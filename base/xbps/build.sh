pkgname=xbps
pkgver=master

fetch() {
	curl -L "https://github.com/void-linux/xbps/archive/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz

	cd $pkgname-$pkgver
	patch -p1 < ../../cert-file.patch
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--build=$TRIPLE \
		--host=$TRIPLE

	sed '/-Werror/d' config.mk > _
	mv _ config.mk
	printf 'LDFLAGS+=-Wl,--allow-shlib-undefined\n' >> config.mk

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}

backup() {
	return
}
