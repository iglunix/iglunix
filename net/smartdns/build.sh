pkgname=smartdns
pkgver=46.1

fetch() {
	curl -L "https://github.com/pymumu/smartdns/archive/refs/tags/Release$pkgver.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv $pkgname-Release$pkgver $pkgname-$pkgver
}

build() {
	cd $pkgname-$pkgver
	bad --gmake gmake
}

package() {
	cd $pkgname-$pkgver

	mkdir -p $pkgdir/usr/sbin/
	cp src/smartdns $pkgdir/usr/sbin
	chmod 755 $pkgdir/usr/sbin/smartdns

	mkdir -p $pkgdir/etc/smartdns/
	cat > $pkgdir/etc/smartdns/smartdns.conf <<EOF
bind [::]:53
mdns-lookup yes
cache-size 32768
server-https https://cloudflare-dns.com/dns-query
EOF
	chmod 644 $pkgdir/etc/smartdns/smartdns.conf
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
#	cat COPYING
}

backup() {
	printf '/etc/smartdns/smartdns.conf'
}
