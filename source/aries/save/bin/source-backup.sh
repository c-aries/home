#! /bin/sh

mydate=`date +"%Y-%m-%d-%s"`
backup_list_tmp="/tmp/backup-source-$mydate"
backupfile=
missingurlfile="/tmp/missing"
workdir="`pwd`"

error()
{
    echo "error: $1" >&2
}

check_bin()
{
# $1 为要安装的程序 $2 为安装的相关网址 $3 为附加的说明
#    echo "checking $1 ..."
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
#    echo "done"
}

usage()
{
    echo "usage: source-backup.sh [online,list]"
    echo "online参数将启动网络备份功能"
    echo "list参数只生成_完整_的备份清单"
}

if [ "$1" = "help" -o "$1" = "h" -o "$1" = "-h" -o "$1" = "--help" ] ; then
    usage
    exit 0
fi

if [ "$1" = "list" ] ; then
	echo "启动生成_完整_备份清单功能"
	backup_list_tmp="/tmp/backup-source-list-$mydate"
fi

if [ -e $missingurlfile ] ; then
    rm $missingurlfile
fi
filename=
count=0
for name in *
do
    if [ -d $name ] ; then
	if [ -f $name/url ] ; then
	    echo "$name/url" >> $backup_list_tmp
	    if [ "$1" = "list" ] ; then
		cd $name
		for filename in *
		do
		    if [ -f "$filename" ] ; then
			if [ "$filename" = "url" -o "$filename" = "readme" -o \
			    "$filename" = "README" -o "$filename" = "repo" ] ; then
			    continue
			fi
			if [ "$filename" = "url~" -o "$filename" = "readme~" -o \
			    "$filename" = "README~" -o "$filename" = "repo~" ] ; then
			    continue
			fi
		    else
			continue
		    fi
		    grep -q "$filename" url
		    if [ $? -eq 0 ] ; then
			echo "$name/$filename" >> $backup_list_tmp
		    else
		    	echo "$name/$filename" >> $missingurlfile
		    fi
		done
		cd "$workdir"
	    fi
	fi
	if [ -f $name/repo ] ; then
	    echo "$name/repo" >> $backup_list_tmp
	fi
	if [ -f $name/readme ] ; then
	    echo "$name/readme" >> $backup_list_tmp
	fi
	if [ -f $name/README ] ; then
	    echo "$name/README" >> $backup_list_tmp
	fi
	if [ -d $name/save/ ] ; then
	    echo "$name/save/" >> $backup_list_tmp
	fi

	if [ -f $name/info/install.sh ] ; then
	    echo "$name/info/install.sh" >> $backup_list_tmp
	fi
	if [ -f $name/info/url ] ; then
	    echo "$name/info/url" >> $backup_list_tmp
	    if [ "$1" = "list" ] ; then
		cd $name/info
		for filename in *
		do
		    if [ -f "$filename" ] ; then
			if [ "$filename" = "url" -o "$filename" = "readme" -o \
			    "$filename" = "README" -o "$filename" = "repo" -o \
			    "$filename" = "install.sh" ] ; then
			    continue
			fi
			if [ "$filename" = "url~" -o "$filename" = "readme~" -o \
			    "$filename" = "README~" -o "$filename" = "repo~" -o \
			    "$filename" = "install.sh~" ] ; then
			    continue
			fi
		    else
			continue
		    fi
		    grep -q "$filename" url
		    if [ $? -eq 0 ] ; then
			echo "$name/info/$filename" >> $backup_list_tmp
		    else
		    	echo "$name/info/$filename" >> $missingurlfile
		    fi
		done
		cd "$workdir"
	    fi
	fi
	if [ -f $name/info/repo ] ; then
	    echo "$name/info/repo" >> $backup_list_tmp
	fi
	if [ -f $name/info/readme ] ; then
	    echo "$name/info/readme" >> $backup_list_tmp
	fi
	if [ -f $name/info/README ] ; then
	    echo "$name/info/README" >> $backup_list_tmp
	fi
	if [ -d $name/info/save/ ] ; then
	    echo "$name/info/save/" >> $backup_list_tmp
	fi
	count=$((count + 1))
    fi
done

mv "$backup_list_tmp" "${backup_list_tmp}-$count"
backup_list_tmp="${backup_list_tmp}-$count"

if [ "$1" = "list" ] ; then
    echo "已生成$backup_list_tmp"
    echo "Missing URL Files List is at '$missingurlfile'"
    touch "$missingurlfile"
    exit 0
fi

backupfile="backup-$mydate-$count-source.tar.bz2"
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
