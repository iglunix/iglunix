pkgver=2.4.122
pkgname=libdrm
# mkdeps="muon:samurai:pkgconf:python"
# mkdeps="muon:pkgconf"
deps="musl"
desc="Userspace interface to kernel DRM services"
bad=""

fetch() {
	curl -L "https://dri.freedesktop.org/libdrm/libdrm-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	cd $pkgname-$pkgver
	patch -p1 < ../../0001-intel-don-t-auto-disable-on-non-x86-platforms.patch
	patch -p1 < ../../0002-intel-HACK-remove-pciaccess-dep.patch
}

build() {
	cd $pkgname-$pkgver
	muon setup $muon_base_args \
		-Dtests=false \
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
