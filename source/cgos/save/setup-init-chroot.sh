#! /bin/bash

CGOS=/media/exp

virtual_file_system()
{
    mount | grep -q "/dev on $CGOS/dev "
    if [ $? -ne 0 ] ; then
	mount -v --bind /dev $CGOS/dev
    fi

    mount | grep -q "devpts on $CGOS/dev/pts "
    if [ $? -ne 0 ] ; then
	mount -vt devpts devpts $CGOS/dev/pts
    fi

    mount | grep -q "shm on $CGOS/dev/shm "
    if [ $? -ne 0 ] ; then
	mount -vt tmpfs shm $CGOS/dev/shm
    fi

    mount | grep -q "proc on $CGOS/proc "
    if [ $? -ne 0 ] ; then
	mount -vt proc proc $CGOS/proc
    fi

    mount | grep -q "sysfs on $CGOS/sys "
    if [ $? -ne 0 ] ; then
	mount -vt sysfs sysfs $CGOS/sys
    fi
}

echo "CGOS setting up ..."

mkdir -pv $CGOS/{dev,proc,sys}
if [ ! -e $CGOS/dev/console ] ; then
   mknod -m 600 $CGOS/dev/console c 5 1
fi
if [ ! -e $CGOS/dev/null ] ; then
   mknod -m 666 $CGOS/dev/null c 1 3
fi

virtual_file_system

mkdir -pv $CGOS/{home,mnt,opt,proc}
mkdir -pv $CGOS/media/{usb,usb2,iso,iso2}
install -dv -m 0750 $CGOS/root
install -dv -m 1777 $CGOS/tmp $CGOS/var/tmp
mkdir -pv $CGOS/usr/{src,local}
mkdir -pv $CGOS/usr/share/man/man{1..8}
mkdir -pv $CGOS/var/{lock,log,mail,run,spool,cache,lib}

touch $CGOS/etc/{passwd,group,mtab}
touch $CGOS/var/run/utmp $CGOS/var/log/{btmp,lastlog,wtmp}
chmod -v 664 $CGOS/var/run/utmp $CGOS/var/log/lastlog

install -dv $CGOS/lib/{firmware,udev/devices/{pts,shm}}
if [ ! -e $CGOS/lib/udev/devices/null ] ; then
mknod -m0666 $CGOS/lib/udev/devices/null c 1 3
fi
