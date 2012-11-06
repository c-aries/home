#! /bin/sh

mount /dev/sdb1 /media/usb
gen_initramfs_list.sh aries > aries.list
gen_init_cpio aries.list > aries.img
gzip -9 aries.img
mv aries.img.gz init.img
cp init.img /media/usb
umount /dev/sdb1