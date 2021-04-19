pkgver=2.4.103
pkgname=libdrm
dep="libpciaccess"
bad=""
ext="dev"

fetch() {
	curl -L "https://dri.freedesktop.org/libdrm/libdrm-2.4.103.tar.xz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	meson build --prefix /usr
	samu -C build
}

package() {
	cd $pkgname-$pkgver
	DESTDIR=$pkgdir samu -C build install
}

package_dev() {
	cd $pkgname-$pkgver
	DESTDIR=$pkgdir samu -C build install
}

license() {
	cat ../COPYING
}
