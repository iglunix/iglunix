pkgname=dropbear
pkgver=2020.81
bad=gmake
ext=doc

ifetch() {
	curl "https://matt.ucc.asn.au/dropbear/releases/dropbear-$pkgver.tar.bz2" -o $pkgname-$pkgver.tar.bz2
	tar -xf $pkgname-$pkgver.tar.bz2
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--build=x86_64-unknown-linux-musl \
		--host=x86_64-unknown-linux-musl

	bad --gmake gmake PROGRAMS='dropbear dbclient dropbearkey dropbearconvert scp'
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir PROGRAMS='dropbear dbclient dropbearkey dropbearconvert scp'
	ln -sr $pkgdir/usr/sbin/dropbear $pkgdir/usr/sbin/sshd
	ln -sr $pkgdir/usr/bin/dbclient $pkgdir/usr/bin/ssh
	rm -r $pkgdir/usr/share
}

package_doc() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir PROGRAMS='dropbear dbclient dropbearkey dropbearconvert scp'
	rm -r $pkgdir/usr/bin
	rm -r $pkgdir/usr/sbin
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}
