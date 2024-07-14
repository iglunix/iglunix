pkgname=gdk-pixbuf
_pkgver=2.42
pkgver=$_pkgver.6

iifetch() {
	curl -L "https://download.gnome.org/sources/gdk-pixbuf/$_pkgver/gdk-pixbuf-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mkdir $pkgname-$pkgver/build
	#rm $pkgdir-$pkgver/subprojects/*.wrap
}

build() {
	cd $pkgname-$pkgver
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Ddebug=false \
		-Djpeg=true \
		-Dpng=true \
		-Dtiff=false \
		-Ddocs=false \
		-Dman=false \
		-Dgio_sniffing=false \
		-Dinstalled_tests=false \
		-Dbuiltin_loaders=all
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
#	cat LICENSE
	cat COPYING
}
