pkgname=mesa
pkgver=24.1.3
#pkgver=main
mkdeps="python:python-mako:samurai"
deps="musl:wayland:wayland-protocols:llvm:zlib-ng:expat:libffi:libdrm:glslang"
ext=dev

ifetch() {
	curl "https://archive.mesa3d.org/$pkgname-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.gz
#	curl "https://gitlab.freedesktop.org/mesa/mesa/-/archive/main/mesa-main.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mkdir $pkgname-$pkgver/build
	cp ../byacc-out-mid-build.patch .
	cp ../alpine-tls.patch .
	cp ../LICENSE .
	cd $pkgname-$pkgver
	busybox sed -i "s|, 'rust_std=2021'||" meson.build
	busybox sed -i 's|if not have_mtls_dialect|if false|' meson.build
#	patch -p1 < ../alpine-tls.patch
}

_dri_drivers=""
_gallium_drivers=""
_vulkan_drivers=""
case $ARCH in
	x86_64)
		_gallium_drivers="nouveau,zink,crocus,i915,iris"
		_vulkan_drivers="amd,intel,intel_hasvk"
		;;

	aarch64)
		_dri_drivers=""
		_gallium_drivers="vc4,v3d,zink"
		_vulkan_drivers="broadcom,panfrost,freedreno"
		;;
esac

build() {
	cd $pkgname-$pkgver
	echo "dri drivers: "$_dri_drivers
	echo "gallium drivers: "$_gallium_drivers
	echo "vulkan drivers: "$_vulkan_drivers

	meson setup \
		-D warning_level=0 \
		-D prefix=/usr \
		-D libdir=lib \
		-D platforms=wayland \
		-D dri3=enabled \
		-D gallium-drivers=$_gallium_drivers \
		-D gallium-vdpau=disabled \
		-D gallium-omx=disabled \
		-D gallium-va=false \
		-D gallium-nine=false \
		-D gallium-opencl=disabled \
		-D vulkan-drivers=$_vulkan_drivers \
		-D shared-glapi=enabled \
		-D gles1=disabled \
		-D gles2=enabled \
		-D opengl=true \
		-D gbm=true \
		-D glx=disabled \
		-D glvnd=true \
		-D egl=true \
		-D llvm=disabled \
		-D shared-llvm=true \
		-D valgrind=false \
		-D libunwind=false \
		-D lmsensors=false \
		-D build-tests=false \
		-D b_ndebug=true \
		-D cpp_rtti=false \
		build

	samu -C build

#	NEEDED IF NOT USING A PATCHED BYACC
#	OR BYACC >= 20210328
#	===================================
#	patch -p1 < ../../byacc-out-mid-build.patch
#	samu
}

package() {
	cd $pkgname-$pkgver
	DESTDIR=$pkgdir meson install -C build
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

backup() {
	return
}
