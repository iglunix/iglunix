pkgname=spirv-tools
pkgver=1.3.261.1
desc="spirv tools"
deps="musl"

iifetch() {
	curl -L "https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/sdk-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv SPIRV-Tools-sdk-$pkgver spirv-tools-$pkgver
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
	samu
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

backup() {
	return
}
