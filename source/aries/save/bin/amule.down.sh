#! /bin/sh

while :
do
    amuled -f
    watch -n 1 amulecmd -c status
    pkill amulegui
    pkill amuled
    ps aux | grep amule
    sleep 2
done
