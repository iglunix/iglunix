pkgname=libxkbcommon
pkgver=1.5.0
deps="libdrm:libxkbcommon"

iifetch() {
	curl -L "https://github.com/xkbcommon/libxkbcommon/archive/xkbcommon-1.0.3.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv $pkgname-xkbcommon-$pkgver $pkgname-$pkgver
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Denable-x11=false \
		-Denable-wayland=true \
		-Denable-docs=false
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
#	cat COPYING
}
