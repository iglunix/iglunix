pkgname=vulkan-tools
pkgver=1.3.261.1
deps="musl"
desc="Vulkan tools"

ifetch() {
	curl -L "https://github.com/KhronosGroup/Vulkan-Tools/archive/refs/tags/sdk-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv Vulkan-Tools-sdk-$pkgver $pkgname-$pkgver
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cp /usr/bin/glslangValidator glslang/linux/bin/glslangValidator
	cd build
	cmake -G Ninja ../ \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DBUILD_WSI_XCB_SUPPORT=OFF \
		-DBUILD_WSI_XLIB_SUPPORT=OFF \
		-DCUBE_WSI_SELECTION=WAYLAND \
		-DSPIRV_HEADERS_INSTALL_DIR="/usr"

	samu
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

backup() {
	return
}
