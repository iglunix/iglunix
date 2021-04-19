#!/bin/sh



HELP="
	-h     This help window
	--help alias to \`-h\`
 
 	-i     install
	-u     uninstall
	-l     outputs the license
	-f     lists installed files
	-d     list dependencies
	-iu    install update or install upgrade
	-ui    alias to \`-iu\`


These needs iglunix-dev (iglupkg) installed
	-b     build
        -bi    build and install the current package
	-biu   build and install update the current package
	-bui   alias to \`-iu\`

NOT IMPLEMENTED:
	-o     root"



usage() {
	echo usage: $(basename "$0") printf "${HELP}" 1>&2
	exit 1
}

error_usage() {
	echo $(basename "$0"): ERROR: "$@" 1>&2
	usage
}

tar_fail() {
	echo "Failed to extract tar"
	exit 1
}

stat_fail() {
	echo "Not a valid package"
	echo "Missing package meta file"
	exit 1
}

find_fail() {
	echo "Package not installed"
	exit 1
}

continue_interactive() {
	printf '%s' "Do you wish to proceed?: "
	read yn
	case $yn in
		[Yy]* ) echo "Proceeding";;
		[Nn]* ) exit;;
		* ) exit;;
	esac
}

already_exists() {
	echo "Package already installed"
	echo "pass -u and -i to upgrade"
	exit 1
}

dep_not_found() {
	echo "Missing dep: $1"
	exit 1
}

iglupkg_check() {
	if ! command -v iglupkg > /dev/null 2>&1; then
		echo "iglupkg from iglunix-dev needs to be installed"
		exit 1
	fi
}

b= bi= i= u= l= f= o= d= iu=



# Handle commandline arguments.
case "$1" in
	-i) i=1;;
	-u) u=1;;
	-l) l=1;;
	-f) f=1;;
	-d) d=1;;
	-iu) iu=1;;
	-ui) iu=1;;
	-b)  b=1;;
	-bi) bi=1;;
	-biu) biu=1;;
	-bui) biu=1;;

	-h)      usage;;
	--help)  usage;;

	*) error_usage "bad argument $i";;
esac
shift

while :
do
    case "$1" in
	-o) shift; o="$1";;
	--) shift; break;;
	-*) usage "bad argument $1";;
	*) break;;
    esac
    shift
done

if [ "$d" = "1" ]; then
#LIST DEPS
	stat /usr/share/iglupkg/$1 > /dev/null 2> /dev/null || find_fail
	grep deps /usr/share/iglupkg/$1 | tr '=' '\n' | grep -v deps | tr ':' '\n'

elif [ "$iu" = "1" ]; then
#INSTALL & UPDATE
	# Setup names
	bname_we=$(basename "$1")
	bname=$(echo "$bname_we" |  cut -f 1 -d '.')

	# locate installed package
	stat /usr/share/iglupkg/$bname > /dev/null 2> /dev/null || find_fail

	echo "Upgrading $bname_we"
	continue_interactive

	# Extract new package and verify
	mkdir -p /tmp/iglunix/$bname_we || exit 1
	tar -xf $1 -C /tmp/iglunix/$bname_we || tar_fail
	stat /tmp/iglunix/$bname_we/usr/share/iglupkg/$bname >/dev/null || stat_fail

	# Check deps
	deps=$(grep deps /tmp/iglunix/$bname_we/usr/share/iglupkg/$bname | tr '=' '\n' | grep -v deps | tr ':' '\n')
	for dep in $deps; do
		stat /usr/share/iglupkg/$dep > /dev/null 2> /dev/null || dep_not_found $dep
    	done

	# Grab a list of old files and new files to install
	OFILES=$(sed -n '/\[fs\]/,$p' /usr/share/iglupkg/$bname |
		grep -v "\[fs\]" | awk '{print length, $0}' | sort -rn | cut -d " " -f2-)
	NFILES=$(sed -n '/\[fs\]/,$p' /tmp/iglunix/$bname_we/usr/share/iglupkg/$bname |
		grep -v "\[fs\]" | awk '{print length, $0}' | sort -rn | cut -d " " -f2-)

	# Extract tar
	tar -xf $1 -C /
	rm -r /tmp/iglunix/$bname_we


	# Remove old files (don't know if this works yet)
	for file in $OFILES; do
		if echo $NFILES | grep -q $file; then
			echo "not removing $file"
		else
    			echo "attempting to remove $file"
    			case $(stat -c "%F" /$file) in
        			directory) rmdir 2>/dev/null /$file;;
        			"regular file") rm /$file;;
        			"symbolic link") rm /$file;;
        			*) break;;
    			esac
    		fi
	done

	echo $OFILES
	echo $NFILES

elif [ "$i" = "1" ]; then
#INSTALL
	bname_we=$(basename "$1")
	bname=$(echo "$bname_we" |  cut -f 1 -d '.')
	stat /usr/share/iglupkg/$bname > /dev/null 2> /dev/null && already_exists
	echo "Installing $bname_we"
	continue_interactive
	mkdir -p /tmp/iglunix/$bname_we || exit 1
	tar -xf $1 -C /tmp/iglunix/$bname_we || tar_fail
	stat /tmp/iglunix/$bname_we/usr/share/iglupkg/$bname >/dev/null || stat_fail
	deps=$(grep deps /tmp/iglunix/$bname_we/usr/share/iglupkg/$bname | tr '=' '\n' | grep -v deps | tr ':' '\n')
	for dep in $deps; do
		stat /usr/share/iglupkg/$dep > /dev/null 2> /dev/null || dep_not_found $dep
    	done
	tar -xf $1 -C /
	rm -r /tmp/iglunix/$bname_we
elif [ "$f" = "1" ]; then
#LIST INSTALLED FILES
	stat /usr/share/iglupkg/$1 > /dev/null 2> /dev/null || find_fail
	sed -n '/\[fs\]/,$p' /usr/share/iglupkg/$1 | grep -v "\[fs\]"

elif [ "$l" = "1" ]; then
#LICENSE
	stat /usr/share/iglupkg/$1 > /dev/null 2> /dev/null || find_fail
	sed -n '/\[license\]/,/\[fs\]/{/\[license\]\|\[fs\]/!p}' /usr/share/iglupkg/$1

elif [ "$u" = "1" ]; then
#UNINSTALL
	stat /usr/share/iglupkg/$1 > /dev/null 2> /dev/null || find_fail
	FILES=$(sed -n '/\[fs\]/,$p' /usr/share/iglupkg/$1 | grep -v "\[fs\]" | awk '{print length, $0}' | sort -rn | cut -d " " -f2-)

	echo "Uninstalling $1"
	continue_interactive

	for file in $FILES; do
    		case $(stat -c "%F" /$file) in
        		directory) rmdir 2>/dev/null /$file;;
        		"regular file") rm /$file;;
        		"symbolic link") rm /$file;;
        		*) echo "can't remove $file";;
    		esac
    	done
elif [ "$b" = "1" ]; then
#BUILD
	iglupkg_check
	iglupkg || exit 1

elif [ "$bi" = "1" ]; then
#BUILD INSTALL
	iglupkg_check
	iglupkg || exit 1
	cd out/
	for pkg in *.tar.xz; do
		iglu -i "$pkg"
	done

elif [ "$biu" = "1" ]; then
#BUILD INSTALL UPDATE
	iglupkg_check
	iglupkg || exit 1
	cd out/
	for pkg in *.tar.xz; do
		iglu -iu "$pkg"
	done
fi
