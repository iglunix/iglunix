pkgname=fontconfig
pkgver=2.14.2

fetch() {
	curl "https://www.freedesktop.org/software/fontconfig/release/$pkgname-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	# cp ../fcobjshash.h $pkgname-$pkgver/src
	mkdir $pkgname-$pkgver/build
	 cd $pkgname-$pkgver
	 sed -i 's/fcobjshash\.h/fcjunk.h/' src/meson.build
	 sed -i "s/find_program(\'gperf/find_program(\'true/" meson.build
}

build() {
	cd $pkgname-$pkgver
	
	cd build
	meson .. \
		--buildtype=release \
		--prefix=/usr \
		--libexecdir=lib \
		-Dnls=disabled \
		-Dtests=disabled
	samu
}

package() {
	cd $pkgname-$pkgver
	cd build
	DESTDIR=$pkgdir samu install
}

license() {
	cd $pkgname-$pkgver
#	cat LICENSE
	cat COPYING
}

backup () {
        return
}
