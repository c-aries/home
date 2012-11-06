#! /bin/sh

mailaddr=babyaries3@gmail.com 	# 你的邮箱
size=18M			# 默认的分割文件粒度
filename=
splitdir="/tmp"
workdir="`pwd`"
sleep_base=60

if [ x"$1" = x"" ] ; then
    echo "usage: mailfile.sh mailaddr(= $mailaddr | default ) filename [ splitsize=$size ] [ resend ]"
    exit 1
elif [ "$1" != "default" ] ; then
    mailaddr="$1"
fi
echo "发送到邮箱 $mailaddr"

if [ x"$2" = x"" ] ; then
    echo "usage: mailfile.sh mailaddr[= $mailaddr] filename [ splitsize=$size ]"
    exit 1
else
    if [ ! -e "$2" ] ; then
	echo "error: 文件 $2 不存在" >&2
	exit 1
    fi
    filename="$2"
    echo "要发送的文件为 $filename"
fi

if [ x"$3" != x"" ] ; then
	size="$3"
fi
echo "分割后每个文件大小为 $size"

rm -fR "$splitdir/sending-$filename"
mkdir "$splitdir/sending-$filename"
cd "$splitdir/sending-$filename"

echo "分割文件中..."
split -a 8 -d -b "$size" "$workdir/$2" "file-"

echo "显示分割后的文件列表"
echo "--------------------------------"
ls
echo "--------------------------------"

filenum=`ls -l /tmp/sending-"$filename"/ | grep "^-" | wc -l`
echo "一共 $filenum 个文件"

if [ "$4" = "resend" ] ; then
    echo "in resend mode"
    echo "请进入/tmp/sending-$filename/进行操作，回车后继续发送邮件，默认等待50秒"
    read -t 50 input
    echo "显示 resend mode 分割后的文件列表"
    echo "--------------------------------"
    ls
    echo "--------------------------------"
    echo "程序要继续进行，发送以上附件吗? ([y]/n)"
    read -s -n 1 -t 5 input
    if [ "$input" = "n" -o "$input" = "N" ] ; then
	exit 1
    fi
fi

echo "开始发送邮件"
for name in *
do
    num=$(echo $name | sed 's/^.*-[0]*\(..*\)$/\1/g')
    num=$((num+1))
    if [ $num -ne 1 ] ; then
	sleep_time=$(echo "$RANDOM % $sleep_base + 1" | bc)
	echo "程序随机睡眠 $sleep_time 秒再发送邮件"
	sleep "$sleep_time"
    fi
    if [ "$filenum" -ne 1 ] ; then
	title="发送 $filename ($num/$filenum) 给你"
	msg="发送 $filename 给你，这是第 $num 个文件 $name ，一共有 $filenum 个文件。请接收完后，将所有相关附件放入一个新建的文件夹内，用命令 cat \`ls file-*\` > `echo $filename | sed 's/ /\\\\ /g'` 还原文件 $filename "
	echo "$msg" | mutt -s "$title" -a "$name" -- "$mailaddr"
    else
	title="发送 $filename 给你"
	msg="发送 $filename 给你"
	echo "$msg" | mutt -s "$title" -a "$workdir/$filename" -- "$mailaddr"
    fi
done
echo
echo "done"
echo

echo "已完成，将删除文件夹/tmp/sending-$filename"
echo "要删除吗? ([y]/n)"
read -s -n 1 -t 5 input
if [ "$input" = "n" -o "$input" = "N" ] ; then
    echo "未删除"
else
    echo "选择了删除"
    rm -fR "/tmp/sending-$filename"
fi
