#! /bin/sh

release="lenny"
workdir="`pwd`"

usage()
{
    echo "usage: apt-iso.sh [-m|-u] iso-name"
    echo "-m mount iso"
    echo "-u umount iso"
}

check_root()
{
    myid=$(id -u)
    if [ $myid -ne 0 ] ; then
	echo "error: only root can run this program" >&2
	exit 1
    fi
}

check_root

if [ "$2"x = ""x ] ; then
    usage
    exit 1
fi

echo "$2" | grep -q "\.iso$"
if [ $? -ne 0 ] ; then
    echo "error: 不是iso后缀的文件" >&2
    exit 1
fi

if [ "$2" = "*.iso" ] ; then
    echo "error: 没有iso文件" >&2
    exit 1
fi


mydir="mount/$(echo "$2" | sed "s/\.iso$//")"
echo "文件夹名称: $mydir"

if [ ! -e "$mydir" ] ; then
    mkdir -p "$mydir"
fi

if [ "$1" = "-m" ] ; then
    mount -o loop "$2" "$mydir"
elif [ "$1" = "-u" ] ; then
    if [ -e "$mydir" ] ; then
	umount "$mydir"
	rmdir "$mydir"
	exit 0
    fi
fi

bin_package=""
src_package=""
for name in "main" "contrib" "non-free"
do
    if [ -e "$workdir/$mydir/dists/$release/$name/binary-i386/Packages" -o -e "$workdir/$mydir/dists/$release/$name/binary-i386/Packages.gz" ] ; then
	bin_package="$bin_package $name"
    fi
    if [ -e "$workdir/$mydir/dists/$release/$name/source/Sources" -o -e "$workdir/$mydir/dists/$release/$name/source/Sources.gz" ] ; then
	src_package="$src_package $name"
    fi
done

echo "$mydir" | grep -q source
if [ $? -ne 0 ] ; then
    if [ "$bin_package"x = ""x ] ; then
	echo "warning: no bin package"
    else
	echo "deb http://localhost/apt/mirror/$mydir $release $bin_package"
	echo "deb http://localhost/apt/mirror/$mydir $release $bin_package" >> sources.list.http
	echo "deb file:$workdir/$mydir $release $bin_package"
	echo "deb file:$workdir/$mydir $release $bin_package" >> sources.list.local
    fi
else
    if [ "$src_package"x = ""x ] ; then
	echo "warning: no src package"
    else
	echo "deb-src http://localhost/apt/mirror/$mydir $release $src_package"
	echo "deb-src http://localhost/apt/mirror/$mydir $release $src_package" >> sources.list.http
	echo "deb-src file:$workdir/$mydir $release $src_package"
	echo "deb-src file:$workdir/$mydir $release $src_package" >> sources.list.local
    fi
fi

echo "$mydir" | grep -q source
if [ $? -ne 0 ] ; then
    for name in "main" "contrib" "non-free"
    do
	if [ -e "$workdir/$mydir/dists/$release/$name/debian-installer/binary-i386/Packages" -o -e "$workdir/$mydir/dists/$release/$name/debian-installer/binary-i386/Packages.gz" ] ; then
	    echo "deb http://localhost/apt/mirror/$mydir $release $name/debian-installer"
	    echo "deb http://localhost/apt/mirror/$mydir $release $name/debian-installer" >> sources.list.http
	    echo "deb file:$workdir/$mydir $release $name/debian-installer"
	    echo "deb file:$workdir/$mydir $release $name/debian-installer" >> sources.list.local
	fi
    done
else
    for name in "main" "contrib" "non-free"
    do
	if [ -e "$workdir/$mydir/dists/$release/$name/debian-installer/source/Sources" -o -e "$workdir/$mydir/dists/$release/$name/debian-installer/source/Sources.gz" ] ; then
	    echo "deb-src http://localhost/apt/mirror/$mydir $release $name/debian-installer"
	    echo "deb-src http://localhost/apt/mirror/$mydir $release $name/debian-installer" >> sources.list.http
	    echo "deb-src file:$workdir/$mydir $release $name/debian-installer"
	    echo "deb-src file:$workdir/$mydir $release $name/debian-installer" >> sources.list.local
	fi
    done
fi
