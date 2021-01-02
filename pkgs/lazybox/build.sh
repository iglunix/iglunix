pkgver=main
pkgname=lazybox
pkgrel=1
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
	install -Dm755 lazy.sh $pkgdir/bin/lazy
}

package_dev() {
	cd $pkgname-$pkgver
	install -d $pkgdir/bin
	install -Dm755 lazypkg.sh $pkgdir/bin/lazypkg

}

license() {
	cd $pkgname-$pkgver
	cat LICENSE
}
