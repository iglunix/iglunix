cat > fdiskscript << EOF
o
n
p
1
63

t
ef
w
EOF
cat fdiskscript | fdisk lazybox.img

losetup -o 32256 /dev/loop0 lazybox.img
mkfs.vfat /dev/loop0
mount /dev/loop0 ./isoroot
#rm -r isoroot/*
cp -r isoout/* isoroot
umount ./isoroot
