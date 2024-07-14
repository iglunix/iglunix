pkgname=weston
pkgver=13.0.3

ifetch() {
	curl "https://gitlab.freedesktop.org/wayland/weston/-/releases/$pkgver/downloads/$pkgname-$pkgver.tar.xz" -LJo $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
	cd $pkgname-$pkgver
	patch -p1 < ../../no-tests.patch
}

build() {
	cd $pkgname-$pkgver
	meson setup \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Dimage-jpeg=false \
		-Dimage-webp=false \
		-Dbackend-drm-screencast-vaapi=false \
		-Dbackend-rdp=false \
		-Dbackend-x11=false \
		-Dxwayland=false \
		-Dcolor-management-lcms=false \
		-Dsystemd=false \
		-Dremoting=false \
		-Dpipewire=false \
		-Ddemo-clients=false \
		build
	samu -C build
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu -C build install
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
