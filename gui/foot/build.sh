pkgname=foot
pkgver=1.13.1

fetch() {
	curl -L "https://codeberg.org/dnkl/foot/archive/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	curl -L "https://codeberg.org/dnkl/fcft/archive/3.1.4.tar.gz" -o fcft.tar.gz
	curl -L "https://codeberg.org/dnkl/tllist/archive/1.1.0.tar.gz" -o tllist.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv $pkgname $pkgname-$pkgver
	mkdir $pkgname-$pkgver/build
	tar -xf fcft.tar.gz -C $pkgname-$pkgver/subprojects
	tar -xf tllist.tar.gz -C $pkgname-$pkgver/subprojects
	cd $pkgname-$pkgver
	patch -p1 < ../../netbsd-tic.patch
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Dterminfo=enabled \
		-Ddefault-terminfo=foot \
		-Dwerror=false
	samu
}

backup() {
	return
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
