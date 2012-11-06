#! /bin/sh

num=8
max=16
loopdev="/dev/loop"
loopfile=""
share_apt_mirror_dir="/var/cache/apt/share-apt/mirror"

usage()
{
    echo "usage: share-apt.sh [-u|-h]"
    echo "default mount iso"
    echo "-u umount iso"
    echo "-h print this help message"
}

check_root()
{
    myid=$(id -u)
    if [ $myid -ne 0 ] ; then
	echo "error: only root can run this program" >&2
	exit 1
    fi
}

check_bin()
{
    which $1 > /dev/null
    if [ $? -ne 0 ] ; then
	echo "error: havn't install $1" >&2
	exit 1
    fi
}

mount_devloop()
{
    while [ $num -le $max ]
    do
	loopfile=${loopdev}${num}
	if [ ! -e $loopfile ] ; then
	    mknod -m660 $loopfile b 7 $num
	    chown root:disk $loopfile
	    ls -l $loopfile
	fi
	num=$((num+1))
    done
}

if [ "$1"x = ""x -o "$1" = "-h" ] ; then
    usage
    exit 1
fi

check_root
check_bin apt-iso.sh
mount_devloop

if [ ! -d "$share_apt_mirror_dir" ] ; then
    echo "error: $share_apt_mirror_dir do not exist"
    exit 1
fi

cd $share_apt_mirror_dir
if [ -e sources.list.local ] ; then
    rm -f sources.list.local
fi
if [ -e sources.list.http ] ; then
    rm -f sources.list.http
fi
for filename in *.iso
do
    if [ "$1" = "-u" ] ; then
	apt-iso.sh -u "$filename"
    else
	apt-iso.sh -m "$filename"
    fi

done
cd - > /dev/null
