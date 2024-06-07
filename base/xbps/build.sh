pkgname=xbps
pkgver=0.59.2
mkdeps=pkgconf:bad:gmake
deps=musl:libarchive:openssl
desc="fast, easy to use and portable package manager"

fetch() {
	curl -L "https://github.com/void-linux/xbps/archive/refs/tags/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz

	cd $pkgname-$pkgver
	patch -p1 < ../../cert-file.patch
	# patch -p1 < ../../openssl3.patch
	# patch -p1 < ../../sig2.patch
	printf 'repository=https://mirror.iglunix.org\n' > data/repod-main.conf
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
