pkgname=go
pkgver=1.22.5
comp=gz

fetch() {
	curl "https://go.dev/dl/go1.22.5.linux-amd64.tar.gz" -LJo $pkgname-$pkgver.tar.$comp
	tar -xf $pkgname-$pkgver.tar.$comp
}

build() {
	echo "bootstrap: already done :)"
}

backup() {
	return
}

package() {
	mkdir -p $pkgdir/opt/
	cp go $pkgdir/opt/go/ -r 
}

license() {
	cd $pkgname
	cat LICENSE
}
