pkgname=mesa
pkgver=21.1.1
deps="musl:wayland:wayland-protocols:llvm:zlib:expat:libffi:libdrm:python-mako"
ext=dev

fetch() {
	curl "https://archive.mesa3d.org/$pkgname-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mkdir $pkgname-$pkgver/build
	cp ../byacc-out-mid-build.patch .
	cp ../alpine-tls.patch .
	cp ../LICENSE .
	cd $pkgname-$pkgver
	patch -p1 < ../alpine-tls.patch
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--prefix=/usr \
		-Dplatforms=wayland \
		-Ddri-drivers=i915,i965 \
		-Ddri3=true \
		-Dgallium-drivers=iris \
		-Dgallium-vdpau=false \
		-Dgallium-xvmc=false \
		-Dgallium-omx=disabled \
		-Dgallium-va=false \
		-Dgallium-xz=false \
		-Dgallium-nine=false \
		-Dgallium-opencl=disabled \
		-Dvulkan-drivers=intel \
		-Dvulkan-overlay-layer=true \
		-Dvulkan-device-select-layer=true \
		-Dshared-glapi=enabled \
		-Dgles1=false \
		-Dgles2=true \
		-Dopengl=true \
		-Dgbm=true \
		-Dglx=disabled \
		-Dglvnd=false \
		-Degl=true \
		-Dllvm=true \
		-Dshared-llvm=true \
		-Dvalgrind=false \
		-Dlibunwind=false \
		-Dlmsensors=false \
		-Dbuild-tests=false \
		-Duse-elf-tls=false

	samu

#	NEEDED IF NOT USING A PATCHED BYACC
#	OR BYACC >= 20210328
#	===================================
#	patch -p1 < ../../byacc-out-mid-build.patch
#	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
	rm -r $pkgdir/usr/include
	rm -r $pkgdir/usr/lib/pkgconfig
}

package_dev() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
	rm -r $pkgdir/usr/share
	rm -r $pkgdir/usr/bin
	rm $pkgdir/usr/lib/*.so
	rm $pkgdir/usr/lib/*.so.*
}

license() {
	cat LICENSE
}
