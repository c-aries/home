#! /bin/sh

echo "请确认 新创建的文件夹 内只含有要转换的视频文件"
read input

i=0
for file in `ls -tr`
do
    mencoder "$file" -oac mp3lame -ovc lavc -mc 0 -idx -o "$i.avi~"
    i=$((i+1))
done

mencoder -oac copy -ovc copy -mc 0 -idx -o object.avi `ls -tr *.avi~`

echo "before delete..."
read input
rm -f *~

echo "合并成一个avi视频文件 object.avi"
