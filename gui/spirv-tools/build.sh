pkgname=spirv-tools
pkgver=2024.2
desc="spirv tools"
deps="musl"

fetch() {
	curl -L "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv SPIRV-Tools-$pkgver spirv-tools-$pkgver
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	cmake -G Ninja ../ \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DSPIRV-Headers_SOURCE_DIR=/usr \
		-DSPIRV_WERROR=Off
	ninja
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir ninja install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}

backup() {
	return
}
