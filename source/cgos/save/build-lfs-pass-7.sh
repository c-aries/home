#! /bin/sh

unset LFS
source lfs.lib

check_root

pass6_warning

build_lfs_bootscripts()
{
    #检测
    cd /sources
    check_file lfs-bootscripts-6.3.tar.bz2
    check_dir lfs-bootscripts-6.3

    #解压
    tar jxvf lfs-bootscripts-6.3.tar.bz2
    cd lfs-bootscripts-6.3

    before_date=`date -R`

    #编译
    make install

    #计时
    after_date=`date -R`
    echo "$before_date"
    echo "$after_date"

    #清理
    cd /sources/
    rm -f -R lfs-bootscripts-6.3
}

configure_setclock()
{
    cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# End /etc/sysconfig/clock
EOF
}

configure_inputrc()
{
    cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF
}

configure_bash()
{
    cat > /etc/profile << "EOF"
# Begin /etc/profile

export LANG=zh_CN.utf8

# End /etc/profile
EOF
}

configure_localnet()
{
    #enter you host name
    echo "HOSTNAME=babyaries" > /etc/sysconfig/network
}

configure_hosts()
{
    cat > /etc/hosts << "EOF"
# Begin /etc/hosts (network card version)

#127.0.0.1 localhost
#<192.168.1.1> <HOSTNAME.example.org> [alias1] [alias2 ...]
127.0.0.1 babyaries localhost

# End /etc/hosts (network card version)
EOF
}

configure_network()
{
    cd /etc/sysconfig/network-devices && \
    mkdir -v ifconfig.eth0 && \
    cat > ifconfig.eth0/ipv4 << "EOF"
ONBOOT=yes
SERVICE=ipv4-static
IP=192.168.1.1
GATEWAY=192.168.1.2
PREFIX=24
BROADCAST=192.168.1.255
EOF
    cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

#domain <Your Domain Name>
#nameserver <IP address of your primary nameserver>
#nameserver <IP address of your secondary nameserver>

nameserver 202.96.128.166
nameserver 202.96.134.133

# End /etc/resolv.conf
EOF
}

network_comment()
{
    echo "******** warning ********"
    echo "please edit /etc/resolv.conf by yourself"
    echo "******** warning ********"
}

build_lfs_bootscripts
configure_setclock
configure_inputrc
configure_bash
configure_localnet
configure_hosts
configure_network

network_comment
