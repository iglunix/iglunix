pkgname=dropbear
pkgver=2020.81
bad=gmake
ext=doc

fetch() {
	curl "https://matt.ucc.asn.au/dropbear/releases/dropbear-2020.81.tar.bz2" -o $pkgname-$pkgver.tar.bz2
	tar -xf $pkgname-$pkgver.tar.bz2
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl

	gmake
}

package() {
	cd $pkgname-$pkgver
	gmake install DESTDIR=$pkgdir
	ln -sr $pkgdir/usr/sbin/dropbear $pkgdir/usr/sbin/sshd
	ln -sr $pkgdir/usr/bin/dbclient $pkgdir/usr/bin/ssh
	rm -r $pkgdir/usr/share
}

package_doc() {
	cd $pkgname-$pkgver
	gmake install DESTDIR=$pkgdir
	rm -r $pkgdir/usr/bin
	rm -r $pkgdir/usr/sbin
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
