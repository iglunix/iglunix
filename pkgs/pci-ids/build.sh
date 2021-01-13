pkgver=2.2
pkgname=pci-ids
pkgrel=1
bad=""
ext=""

fetch() {
	mkdir $pkgname-$pkgver
	cd $pkgname-$pkgver
	curl "https://pci-ids.ucw.cz/v2.2/pci.ids" -o pci.ids
}

build() {
	cd $pkgname-$pkgver
	echo "Nothing to do"
}

package() {
	cd $pkgname-$pkgver
	install -d $pkgdir/usr/share/misc
	install -Dm 644 pci.ids $pkgdir/usr/share/misc
}

license() {
	cd $pkgname-$pkgver
	echo "The contents of the database and the generated files can be distributed"
	echo "under the terms of either the GNU General Public License (version 2 or later)"
	echo "or of the 3-clause BSD License. The database is a compilation of factual data,"
	echo "and as such the copyright only covers the aggregation and formatting."
}
