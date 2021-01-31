pkgver=main
pkgname=lazybox
pkgrel=1
deps="busybox:toybox"
bad=""
ext="dev"

fetch() {
	mkdir $pkgname-$pkgver
	cd $pkgname-$pkgver
	cp ../../../../lazy*.sh .
	cp ../../../../LICENSE .
}

build() {
	cd $pkgname-$pkgver
	echo "Nothing to do"
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/bin
	install -Dm755 lazy.sh $pkgdir/usr/sbin/lazy
}

package_dev() {
	cd $pkgname-$pkgver
	install -d $pkgdir/bin
	install -Dm755 lazypkg.sh $pkgdir/usr/bin/lazypkg
}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
