pkgname=wlroots
pkgver=0.15.1

fetch() {
	curl -L "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/$pkgver/wlroots-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
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
		-Dxcb-errors=disabled \
		-Dxwayland=disabled \
		-Dexamples=false \
		-Drenderers="['gles2', 'vulkan']" \
		-Dbackends="['drm', 'libinput']" \
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
