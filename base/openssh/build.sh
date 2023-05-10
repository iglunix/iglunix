pkgname=openssh
pkgver=9.3p1

fetch() {
	curl "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
}

build() {
	cd $pkgname-$pkgver
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc/ssh \
		--build=$TRIPLE \
		--host=$TRIPLE \
		--libexecdir=/usr/lib

	make
}

package() {
	cd $pkgname-$pkgver
	make install DESTDIR=$pkgdir

	mkdir -p $pkgdir/etc/init.d/sshd

	cat >> $pkgdir/etc/init.d/sshd/run << EOF
#!/bin/sh

set -- /etc/ssh/sshd_host_*_key
if [ ! -e "\$1" ]
then
	ssh-keygen -A
fi

exec /usr/sbin/sshd -D
EOF

	chmod +x $pkgdir/etc/init.d/sshd/run

	cat >> $pkgdir/etc/init.d/sshd/deps << EOF
net
EOF
}

backup() {
    return
}

license() {
	cd $pkgname-$pkgver
	cat LICENCE
}
