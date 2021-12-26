pkgver=2.4.109
pkgname=libdrm
dep="libpciaccess"
bad=""

fetch() {
	curl -L "https://dri.freedesktop.org/libdrm/libdrm-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.gz
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

backup() {
    return
}

license() {
	cat ../COPYING
}
