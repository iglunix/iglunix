pkgname=libdisplay-info
pkgver=0.2.0
deps="libdrm:libxkbcommon:libudev-zero:pixman:mesa:libglvnd:vulkan-headers:vulkan-icd-loader:hwdata:libinput:seatd"

fetch() {
	curl -L "https://gitlab.freedesktop.org/emersion/libdisplay-info/-/archive/$pkgver/libdisplay-info-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		--libdir=lib
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

backup() {
    return
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
