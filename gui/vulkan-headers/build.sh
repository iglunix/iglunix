pkgname=vulkan-headers
pkgver=1.3.270
#mkdeps=cmake:samurai
desc="Vulkan Headers"
deps=musl

ifetch() {
	curl -L "https://github.com/KhronosGroup/Vulkan-Headers/archive/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv Vulkan-Headers-$pkgver $pkgname-$pkgver
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	cmake -G Ninja ../ \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib
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
	cat LICENSE.md
#	cat COPYING
}
