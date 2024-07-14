pkgname=openjdk17
pkgver=17.0.4.1

iifetch() {
	curl -L "https://cdn.azul.com/zulu/bin/zulu17.36.17-ca-jdk$pkgver-linux_musl_x64.tar.gz" -o $pkgname-$pkgver.tar.xz
	tar -xf $pkgname-$pkgver.tar.xz
	mv zulu* $pkgname-$pkgver
}

build() {
	return
}

package() {
	cd $pkgname-$pkgver

	mkdir -p $pkgdir/usr/lib/jvm/$pkgname
	cp -r * $pkgdir/usr/lib/jvm/$pkgname
}

license() {
	cd $pkgname-$pkgver
	# cat LICENSE
#	cat COPYING
}

backup() {
	return
}
