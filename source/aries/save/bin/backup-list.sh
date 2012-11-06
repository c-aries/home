#! /bin/sh
#按照backup-list进行备份，含网络备份功能，主要用来备份系统配置、程序源代码等重要数据

topdir="$HOME"
mydate=`date +"%Y-%m-%d-%s"`
backup_list="$topdir/.backup.list"
backup_list_tmp="/tmp/backup-list-$mydate"
backupfile="backup-$mydate-list.tar.bz2"

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
    echo "usage: backup-list.sh [online]"
    echo "online参数将启动网络备份功能"
}

if [ "$1" = "help" -o "$1" = "h" -o "$1" = "-h" -o "$1" = "--help" ] ; then
    usage
    exit 0
fi

check_bin makebooks.sh "http://blog.linuxeden.com/?uid-196616-action-viewspace-itemid-7188"

ls -l "$backup_list"

if [ ! -e "$backup_list" ] ; then
    error " $backup_list 不存在"
    echo "请编辑 $backup_list ,在里面按行输入你想要备份的文件或文件夹"
    exit 1
fi

i=0
while read name
do
    if [ -e "$name" ] ; then
	if [ -d "$name" ] ; then
	    echo "清理目录$name下的垃圾文件"
	    cd "$name"
	    makebooks.sh -c
	    cd ..
	fi
	i=$((i+1))
    fi
done < "$backup_list"

if [ $i -eq 0 ] ; then
    error "$backup_list 内容为空"
    echo "请编辑 $backup_list ,在里面按行输入你想要备份的文件或文件夹"
    exit 1
fi

grep -v "^#" "$backup_list" > "$backup_list_tmp"
cd "$topdir"
tar jcvf "$backupfile" -T "$backup_list_tmp"

if [ $? -eq 0 ] ; then
    echo "备份完成"
    rm -f "$backup_list_tmp"
    if [ "$1" = "online" ] ; then
	echo "启动网络备份功能"
	check_bin mailfile.sh "http://blog.linuxeden.com/index.php/196616/viewspace-7552.html"
	mailfile.sh default "$backupfile"
	echo "删除备份文件 $backupfile 吗?([y]/n)"
	read -s -n 1 -t 5 input
	if [ "$input" = "n" -o "$input" = "N" ] ; then
	    echo "未删除"
	else
	    echo "选择了删除"
	    rm -f "$backupfile"
	fi
    fi
else
    echo "备份失败"
    rm -f "$backup_list_tmp"
fi

echo "程序结束"
