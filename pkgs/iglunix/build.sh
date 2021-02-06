pkgver=main
pkgname=iglunix
pkgrel=1
deps="busybox:toybox"
bad=""
ext="dev"

fetch() {
	mkdir $pkgname-$pkgver
	cp ../profile.sh .
	cp ../motd .
	cd $pkgname-$pkgver
	cp ../../../../iglu*.sh .
	cp ../../../../LICENSE .
}

build() {
	cd $pkgname-$pkgver
	echo "Nothing to do"
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/etc/
	install -Dm644 ../profile.sh $pkgdir/etc/profile
	install -Dm644 ../motd $pkgdir/etc/
	install -d $pkgdir/usr/sbin
	install -Dm755 iglu.sh $pkgdir/usr/sbin/iglu
}

package_dev() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/bin
	install -Dm755 iglupkg.sh $pkgdir/usr/bin/iglupkg
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
