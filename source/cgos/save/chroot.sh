#! /bin/bash

CGOS=/media/exp

mount -v --bind /dev $CGOS/dev
mount -vt devpts devpts $CGOS/dev/pts
mount -vt tmpfs shm $CGOS/dev/shm
mount -vt proc proc $CGOS/proc
mount -vt sysfs sysfs $CGOS/sys
