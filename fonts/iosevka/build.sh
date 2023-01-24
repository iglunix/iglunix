pkgname=iosevka
pkgver=17.1.0                                                                                                         
                                                                                                                     
fetch() {                                                                                                            
	curl -L "https://github.com/be5invis/Iosevka/releases/download/v17.1.0/ttf-iosevka-17.1.0.zip" -o $pkgname-$pkgver.zip
	unzip $pkgname-$pkgver.zip -d $pkgname-$pkgver                                                                          
                                                                                                                     
}                                                                                                                    
                                                                                                                     
build() {                                                                                                            
	cd $pkgname-$pkgver
}                                                                                                                    
                                                                                                                     
backup() {                                                                                                           
}                                                                                                                    
                                                                                                                     
package() {                                                                                                          
        cd $pkgname-$pkgver                                                                                          
        mkdir -p $pkgdir/usr/share/fonts                                                                                                         
        mv ./* $pkgdir/usr/share/fonts                                                                          
}                                                                                                                    
                                                                                                                     
license() {                                                                                                          
        cd $pkgname-$pkgver                                                                                          
#       cat LICENSE                                                                                                  
#       cat COPYING
	echo "SIL Open Font License v1.1"                                                                                                  
}           
