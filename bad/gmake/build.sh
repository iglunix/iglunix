pkgver=4.3
pkgname=gmake
pkgrel=1
deps="musl"
bad="gmake"
ext="doc:dev"

fetch() {
	curl "https://ftp.gnu.org/gnu/make/make-4.3.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
	mv make-$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--program-prefix=g \
		--disable-nls
	make
}

package() {
	cd $pkgname-$pkgver
	./make install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/share
	rm -r $pkgdir/usr/include
}

package_doc() {
	cd $pkgname-$pkgver
	./make install DESDIR=$pkgdir
	rm -r $pkgdir/usr/bin
	rm -r $pkgdir/usr/share/info
	rm -r $pkgdir/usr/include
}
package_dev() {
	cd $pkgname-$pkgver
	./make install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/bin
	rm -r $pkgdir/usr/share
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}
