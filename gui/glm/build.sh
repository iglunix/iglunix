pkgname=glm
pkgver=0.9.9.8

iifetch() {
	curl -L "https://github.com/g-truc/glm/archive/refs/tags/$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mkdir $pkgname-$pkgver/build
}

build() {
	cd $pkgname-$pkgver
	cd build
	cmake -G Ninja ../ \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DCMAKE_CXX_FLAGS='-Wno-implicit-int-float-conversion -Wno-implicit-int-conversion'
	samu
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/include
	cp -r ./glm $pkgdir/usr/include/
	install -d $pkgdir/usr/lib/pkgconfig
	cp ../../glm.pc $pkgdir/usr/lib/pkgconfig
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
