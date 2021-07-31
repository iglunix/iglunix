pkgname=shaderc
pkgver=main

fetch() {
	curl -L "https://github.com/google/shaderc/archive/refs/heads/main.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	cp ../third-party.patch .
	mkdir $pkgname-$pkgver/build
	cd $pkgname-$pkgver
	patch -p1 < ../third-party.patch
	echo \"$pkgver\" > glslc/src/build-version.inc
}

build() {
	cd $pkgname-$pkgver
	cd build
	cmake -G Ninja ../ \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DSHADERC_SKIP_TESTS=ON \
		-Dglslang_SOURCE_DIR=/usr/include/glslang
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
