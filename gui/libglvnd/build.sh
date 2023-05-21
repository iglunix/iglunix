pkgname=libglvnd
pkgver=1.5.0
mkdeps=samurai:muon:pkgconf:python

fetch() {
	curl -L "https://gitlab.freedesktop.org/glvnd/libglvnd/-/archive/v$pkgver/libglvnd-v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv $pkgname-v$pkgver $pkgname-$pkgver
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
