#!/bin/bash

curl -Oks https://raw.githubusercontent.com/Morton-L/HeadScript_Linux/main/loader.sh
source loader.sh font

trap _exit INT QUIT TERM
_exit() {
    red "\n脚本已终止.\n"
    exit 1
}

io_test() {
    (LANG=C dd if=/dev/zero of=benchtest_$$ bs=64k count=16k conv=fdatasync && rm -f benchtest_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}
ExternalEnv
green " =================================================="
bold " I/O速度测试脚本"
green " =================================================="
io1=$( io_test )
echo " I/O 速度(1st run)    : $(yellow "$io1")"
sleep 1s
io2=$( io_test )
echo " I/O 速度(2nd run)    : $(yellow "$io2")"
sleep 1s
io3=$( io_test )
echo " I/O 速度(3rd run)    : $(yellow "$io3")"
sleep 1s
ioraw1=$( echo $io1 | awk 'NR==1 {print $1}' )
[ "`echo $io1 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw1=$( awk 'BEGIN{print '$ioraw1' * 1024}' )
ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
[ "`echo $io2 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw2=$( awk 'BEGIN{print '$ioraw2' * 1024}' )
ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
[ "`echo $io3 | awk 'NR==1 {print $2}'`" == "GB/s" ] && ioraw3=$( awk 'BEGIN{print '$ioraw3' * 1024}' )
ioall=$( awk 'BEGIN{print '$ioraw1' + '$ioraw2' + '$ioraw3'}' )
ioavg=$( awk 'BEGIN{printf "%.1f", '$ioall' / 3}' )
echo -e " 平均 I/O 速度       : $(yellow "$ioavg MB/s")"
green " =================================================="