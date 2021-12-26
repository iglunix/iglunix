pkgname=mesa
#pkgver=21.2.1
pkgver=main
deps="musl:wayland:wayland-protocols:llvm:zlib-ng:expat:libffi:libdrm:python-mako"
ext=dev

fetch() {
#	curl "https://archive.mesa3d.org/$pkgname-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.gz
	curl "https://gitlab.freedesktop.org/mesa/mesa/-/archive/main/mesa-main.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mkdir $pkgname-$pkgver/build
	cp ../byacc-out-mid-build.patch .
	cp ../alpine-tls.patch .
	cp ../LICENSE .
	cd $pkgname-$pkgver
	patch -p1 < ../alpine-tls.patch
}

_dri_drivers=""
_gallium_drivers=""
_vulkan_drivers=""
case $ARCH in
	x86_64)
		_dri_drivers="i915,i965,nouveau"
		_gallium_drivers="iris"
		_vulkan_drivers="intel"
		;;

	aarch64)
		_dri_drivers=""
		_gallium_drivers="vc4,v3d,zink"
		_vulkan_drivers="broadcom"
		;;
esac

build() {
	cd $pkgname-$pkgver
	cd build
	echo "dri drivers: "$_dri_drivers
	echo "gallium drivers: "$_gallium_drivers
	echo "vulkan drivers: "$_vulkan_drivers

	meson .. \
		--prefix=/usr \
		-Dplatforms=wayland \
		-Ddri-drivers=$_dri_drivers \
		-Ddri3=true \
		-Dgallium-drivers=$_gallium_drivers \
		-Dgallium-vdpau=false \
		-Dgallium-xvmc=false \
		-Dgallium-omx=disabled \
		-Dgallium-va=false \
		-Dgallium-xz=false \
		-Dgallium-nine=false \
		-Dgallium-opencl=disabled \
		-Dvulkan-drivers=$_vulkan_drivers \
		-Dvulkan-overlay-layer=true \
		-Dvulkan-device-select-layer=true \
		-Dshared-glapi=enabled \
		-Dgles1=false \
		-Dgles2=true \
		-Dopengl=true \
		-Dgbm=true \
		-Dglx=disabled \
		-Dglvnd=true \
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
