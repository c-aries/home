#! /bin/sh

dir="`pwd`"
name=`basename "$dir"`		# 注意要加引号
date="`date +%Y-%m-%d-%s`"
backup="$name-$date.tar.bz2"

error()
{
    echo "error: $1" >&2
}

check_bin()
{
# $1 为要安装的程序 $2 为安装的相关网址 $3 为附加的说明
    echo "checking $1 ..."
    which "$1" > /dev/null
    if [ $? -ne 0 ] ; then
	error "程序 $1 尚未安装"
	if [ x"$2" != x"" ] ; then
            echo "可尝试从 $2 获得 $1 安装的相关信息"
	fi
	if [ x"$3" != x"" ] ; then
            echo "附加说明: $3"
	fi
	exit 1
    fi
    echo "done"
}

usage()
{
    echo "usage: backup-fast.sh [online]"
    echo "online参数将启动网络备份功能"
}

if [ "$1" = "help" -o "$1" = "h" -o "$1" = "-h" -o "$1" = "--help" ] ; then
    usage
    exit 0
fi

if [ "$name" = "/" ] ; then
    error "不能备份根目录"
    exit 1
fi

check_bin makebooks.sh "http://blog.linuxeden.com/?uid-196616-action-viewspace-itemid-7188"

makebooks.sh -c

cd ..
touch "$name/$backup"
echo "文件归档中..."
tar jcvf "$name/$backup" "$name" --exclude "$name/$name-[0-9]*-[0-9]*-[0-9]*-[0-9]*\.tar\.bz2"
if [ $? -eq 0 ] ; then
    cd -
    echo "生成备份文件 $backup"
    if [ "$1" = "online" ] ; then
	echo "启动网络备份功能"
	check_bin mailfile.sh "http://blog.linuxeden.com/index.php/196616/viewspace-7552.html"
	mailfile.sh default "$backup"
	echo "删除备份文件 $backup 吗?([y]/n)"
	read -s -n 1 -t 5 input
	if [ "$input" = "n" -o "$input" = "N" ] ; then
            echo "未删除"
	else
            echo "选择了删除"
            rm -f "$backup"
	fi
    fi
    echo "备份完成"
else
    cd -
    echo "备份失败"
fi
