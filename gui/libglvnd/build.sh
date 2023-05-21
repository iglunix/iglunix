pkgname=libglvnd
pkgver=master
mkdeps=samurai:muon:pkgconf

fetch() {
	curl -L "https://github.com/NVIDIA/libglvnd/archive/refs/heads/master.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
	cd $pkgname-$pkgver
	sed -i "s|if not gl_dispatch_type.endswith('_tls')|if false|" meson.build
}

build() {
	cd $pkgname-$pkgver
	muon setup \
		-Dbuildtype=release \
		-Ddefault_library=shared \
		-Dprefix=/usr \
		-Dlibexecdir=lib \
		-Dlibdir=lib \
		-Dtls=false \
		build
	samu -C build
}

package() {
	cd $pkgname-$pkgver
	DESTDIR=$pkgdir muon -C build install
}

license() {
	cd $pkgname-$pkgver
	tail -n 20 README.md
#	cat COPYING
}

backup() {
	return
}
