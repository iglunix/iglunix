pkgname=vulkan-icd-loader
pkgver=1.3.269
desc="vulkan loader"
deps="musl"

ifetch() {
	curl -L "https://github.com/KhronosGroup/Vulkan-Loader/archive/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv Vulkan-Loader-$pkgver $pkgname-$pkgver
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	cmake -G Ninja ../ \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DBUILD_WSI_WAYLAND_SUPPORT=On \
		-DBUILD_WSI_XLIB_SUPPORT=OFF \
		-DBUILD_WSI_XCB_SUPPORT=OFF \
		-DBUILD_WSI_DISPLAY_SUPPORT=ON
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
	cat LICENSE.txt
#	cat COPYING
}
