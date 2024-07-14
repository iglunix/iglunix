pkgver=6.8.2
pkgname=doas
pkgrel=1
bad="gmake"
ext="doc"
auto_cross

iiifetch() {
	curl -L "https://github.com/Duncaen/OpenDoas/releases/download/v$pkgver/opendoas-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv opendoas-$pkgver $pkgname-$pkgver
	cp ../build.ninja $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	./configure --prefix=/usr \
	--without-pam
	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/bin
	install -Dm755 doas $pkgdir/usr/bin
	chmod u+s $pkgdir/usr/bin/doas
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}

backup() {
	return
}
