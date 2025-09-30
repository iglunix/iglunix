pkgname=iwd
subpkgs=iwd
pkgver=3.10

fetch() {
	curl "https://mirrors.edge.kernel.org/pub/linux/network/wireless/iwd-$pkgver.tar.xz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--libexecdir=/usr/lib \
		--localstatedir=/var \
		--build=$TRIPLE \
		--host=$TRIPLE \
		--disable-systemd-service \
		--enable-dbus-policy \
		--enable-client \
		--enable-libedit

	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver
	bad --gmake gmake install DESTDIR=$pkgdir

	mkdir -p $pkgdir/etc/iwd
	cat > $pkgdir/etc/iwd/main.conf <<EOF
[General]
EnableNetworkConfiguration=true
EOF
}

iwd() {
	find .
}

license() {
	cd $pkgname-$pkgver
	cat COPYING
}

backup() {
	return
}
