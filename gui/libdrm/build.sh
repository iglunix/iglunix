pkgver=2.4.118
pkgname=libdrm
# mkdeps="muon:samurai:pkgconf:python"
# mkdeps="muon:pkgconf"
deps="musl"
desc="Userspace interface to kernel DRM services"
bad=""

fetch() {
	curl -L "https://dri.freedesktop.org/libdrm/libdrm-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	muon setup $muon_base_args \
		build
	samu -C build
}

package() {
	cd $pkgname-$pkgver
	DESTDIR=$pkgdir muon -C build install
}

backup() {
    return
}

license() {
	cat ../COPYING
}
