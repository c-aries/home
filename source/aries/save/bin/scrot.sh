#!/bin/sh

sleep_time=3
repeat_time=10
i=1
info="程序运行时出现异常,自动退出!"

if [ $# -ge 3 ] ; then
    echo "参数过多"
    echo "$info"
    exit 1
fi

if [ $# -eq 1 ] ; then
    sleep_time=$1
elif [ $# -eq 2 ] ; then
    sleep_time=$1
    repeat_time=$2
fi


echo "共截屏$repeat_time次,每截一次间隔$sleep_time秒"
echo "开始截屏"
while [ $i -le $repeat_time ]
do
    sleep $sleep_time
    echo "$i/$repeat_time"
    scrot
    i=$((i+1))
done

echo "程序结束"
exit 0
