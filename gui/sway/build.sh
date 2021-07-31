pkgname=sway
pkgver=master

fetch() {
	curl -L "https://github.com/DCVIII/sway/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.gz
	# local wlroots isn't new enough
	curl -L "https://github.com/swaywm/wlroots/archive/refs/heads/master.tar.gz" -o wlroots-master.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	tar -xf wlroots-master.tar.gz
	mkdir $pkgname-$pkgver/subprojects
	mv wlroots-master $pkgname-$pkgver/subprojects/wlroots
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	CFLAGS=-'Wno-unused-const-variable -Wno-unused-function -Wno-error' \
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Dexamples=false \
		-Dxwayland=disabled \
		-Dxcb-errors=disabled \
		-Dxcb-icccm=disbeld \
		-Dwlroots:examples=false \
		-Dwlroots:xcb-errors=disabled \
		-Dwlroots:x11-backend=disabled \
		-Dwlroots:default_library=static

	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install

	rm -rf $pkgdir/usr/lib/
	rm -rf $pkgdir/usr/include/
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
