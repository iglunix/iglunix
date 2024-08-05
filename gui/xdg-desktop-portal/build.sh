pkgname=xdg-desktop-portal
pkgver=1.14.4
dep="glib:json-glib:libportal"

fetch() {
	curl -L "https://github.com/flatpak/xdg-desktop-portal/releases/download/$pkgver/xdg-desktop-portal-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--build=$TRIPLE \
		--host=$TRIPLE \
		--disable-geoclue \
		--without-systemd

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir
}
license() {
	cd $pkgname-$pkgver
	cat COPYING
}

backup() {
	return
}
