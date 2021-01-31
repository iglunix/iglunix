pkgname=weston
pkgver=9.0.0

fetch() {
	curl "https://wayland.freedesktop.org/releases/$pkgname-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
	cd $pkgname-$pkgver
	patch -p1 < ../../no-tests.patch
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Dimage-jpeg=false \
		-Dimage-webp=false \
		-Dlauncher-logind=false \
		-Dweston-launch=true \
		-Dbackend-drm-screencast-vaapi=false \
		-Dbackend-rdp=false \
		-Dbackend-x11=false \
		-Dxwayland=false \
		-Dcolor-management-lcms=false \
		-Dcolor-management-colord=false \
		-Dsystemd=false \
		-Dremoting=false \
		-Dpipewire=false \
		-Ddemo-clients=false \
		-Dtests=false \
		-Dtest-gl-renderer=false
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
