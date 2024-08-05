pkgname=libportal
pkgver=0.6
deps="gtk+"

fetch() {
	curl -L "https://github.com/flatpak/libportal/releases/download/$pkgver/libportal-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Dintrospection=false \
		-Dbackends=gtk3 \
		-Ddocs=false \
		--libdir=lib
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}

backup() {
	return
}
