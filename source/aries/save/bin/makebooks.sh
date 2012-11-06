#!/bin/sh

filepath=
filetype=
bookname=book-`date '+%F'`
decorate="--------------------------------------------------------------------"
currentdir=`pwd`
calc=0

deco()
{
    if [ $((calc%2)) -eq 0 -a $calc -ne 0 ] ; then
	echo >> $bookname
    fi
    calc=$((calc+1))
    echo "$decorate" >> $bookname
}

if [ -e "$bookname" ] ; then
    rm -f "$bookname"
fi

find -type f | sed -e 's/\\/\\\\/g' | sed -n -e '/^.*~$/p' | while read filepath
do
	rm -f "$filepath"
done

if [ "$1" =  "-c" ] ; then
#    echo "clean mode : makebooks.sh只启用了clean功能"
    input="q"
else
    echo "垃圾文件处理完毕,回车确认(q或Q退出)"
    read -s -n 1 -t 5 input
fi


if [ "$input" = "q" -o "$input" = "Q" ] ; then
	exit 0
fi

deco
echo "[`basename "$currentdir"`目录结构]" >> $bookname
deco
tree >> $bookname

find | sed -e 's/\\/\\\\/g' | sed -e '/.\/'"$bookname"'/d' | while read filepath
do
    if [ -f "$filepath" ] ; then
	filetype=`file "$filepath"`
	filetype=${filetype#* }
	echo "$filetype" | grep -q "text"
	if [ $? -eq 0 ] ; then
	    deco
	    echo "[$filepath]" >> $bookname
	    deco
	    cat "$filepath" >> $bookname
	fi
    fi
done

echo "$bookname制作完毕"
