#! /bin/sh

unset LFS
source lfs.lib

check_root

pass6_warning

configure_fstab()
{
    cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type   options         dump  fsck
#                                                        order

/dev/sda9     /            ext3  defaults        1     1
/dev/sda3     swap         swap   pri=1           0     0
proc           /proc        proc   defaults        0     0
sysfs          /sys         sysfs  defaults        0     0
devpts         /dev/pts     devpts gid=4,mode=620  0     0
shm            /dev/shm     tmpfs  defaults        0     0
# End /etc/fstab
EOF
}

build_linux()
{
    #检测
    cd /sources
    check_file linux-2.6.22.5.tar.bz2
    check_dir linux-2.6.22.5

    #解压
    tar jxvf linux-2.6.22.5.tar.bz2
    cd linux-2.6.22.5

    before_date=`date -R`

    #编译
    make mrproper
    echo "wanna to run 'make menuconfig' ? (y/[n])"
    echo "if you press 'n', you should copy your own .config to `pwd`"
    read -s -n 1 -t 20 input
    if [ "$input" = "y" -o "$input" = "Y" ] ; then
	make menuconfig
    else
	if [ ! -e .config ] ; then
	    echo "error: .config doesn't exist"
	    exit 1
	fi
    fi
    make || eval "echo \"error: make error in linux\" && exit 1"
    make modules_install

    #计时
    after_date=`date -R`
    echo "$before_date"
    echo "$after_date"

    #特殊
    cp -v arch/i386/boot/bzImage /boot/lfskernel-2.6.22.5
    cp -v System.map /boot/System.map-2.6.22.5
    cp -v .config /boot/config-2.6.22.5
    install -d /usr/share/doc/linux-2.6.22.5
    cp -r Documentation/* /usr/share/doc/linux-2.6.22.5

    #清理
    cd /sources/
    rm -f -R linux-2.6.22.5
}

configure_grub()
{
    cat > /boot/grub/menu.lst << "EOF"
# Begin /boot/grub/menu.lst

# By default boot the first menu entry.
default 0

# Allow 30 seconds before booting the default.
timeout 2

# Use prettier colors.
color green/black light-green/black

# The first entry is for LFS.
title LFS 6.3
root (hd0,8)
kernel /boot/lfskernel-2.6.22.5 root=/dev/sda9
EOF
    mkdir -pv /etc/grub
    ln -sv /boot/grub/menu.lst /etc/grub
}

configure_lfs()
{
    echo 6.3 > /etc/lfs-release
}

logout_comment()
{
    echo "******** warning ********"
    echo "please edit /etc/fstab by yourself"
    echo "please edit /boot/grub/menu.lst by yourself"
    echo "then login as root, run the following commands to setup grub"
    echo "这里的命令很危险！请修改grub> 下的命令参数"
    echo "hd0,8 指第1块磁盘，第9个分区"
    echo
    echo "示例:"
    echo "# grub"
    echo "grub> root (hd0,8)"
    echo "grub> setup (hd0)"
    echo "grub> quit"
    echo "# logout"
    echo 
    echo "the logout from chroot enviroment"
    echo "******** warning ********"
}

configure_fstab
build_linux
configure_grub
configure_lfs

logout_comment
