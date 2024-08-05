pkgname=weston
pkgver=13.0.0

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
	CFLAGS="-Wno-int-conversion -Wno-implicit-function-declaration" meson .. \
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
		-Dpipewire=true \
		-Ddemo-clients=false 
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
#	cat LICENSE
	cat COPYING
}

backup() {
	return
}
