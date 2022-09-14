pkgname=pango
_pkgver=1.48
pkgver=$_pkgver.10

fetch() {
	curl -L "https://download.gnome.org/sources/pango/$_pkgver/pango-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
	cd $pkgname-$pkgver
	rm -rf subprojects
	: > tests/meson.build
	: > examples/meson.build
	: > docs/meson.build
	patch -p1 < ../../no-fribidi.patch
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Dgtk_doc=false \
		-Dxft=disabled \
		-Dintrospection=disabled \
		--libdir=lib
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

backup() {
	return
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
