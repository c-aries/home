#! /bin/bash
#http://www.flvcd.com
#wget --user-agent="Mozilla/5.0" -c -i play.m3u 

ls -cr | grep -v play.m3u > /tmp/youku

num=0

while read name
do
    mv "$name" `printf "%03d.flv" $num`
    num=$((num + 1))
done < /tmp/youku