pkgname=oslo
pkgver=0.0.1

fetch() {
	curl -L "https://github.com/iglunix/oslo/archive/refs/tags/v$pkgver.tar.gz" -o $pkgname-$pkgver.tar.gz
	tar -xf $pkgname-$pkgver.tar.gz
}

build() {
	cd $pkgname-$pkgver
	make ARCH=$ARCH
}

case $ARCH in
	aarch64)
		_a=aa64
		;;
	x86_64)
		_a=x64
		;;
	*)
		exit 1
		;;
esac

package() {
	cd $pkgname-$pkgver
	install -Dm755 oslo.efi $pkgdir/boot/efi/boot/boot$_a.efi
	install -Dm644 efi/oslo/entries.ini $pkgdir/boot/efi/oslo/entries.ini
}

license() {
	cd $pkgname-$pkgver
	cat license.txt
}

backup() {
	echo boot/efi/oslo/entries.ini
}
