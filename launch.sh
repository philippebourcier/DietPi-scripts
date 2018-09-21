#!/bin/bash

if [ ! -x /usr/local/bin/TheBigLEDowSPI ]; then
	exit 0
fi

while [ 1 ]; do

# launching the program
# the chrt thing sets the process as being realtime on the kernel side
# ...and of course, you can launch another process on /dev/spidev1.0

zps=`pgrep -c TheBigLEDowSPI`
if [ $zps -lt 1 ] ; then
        /usr/local/bin/TheBigLEDowSPI 127.0.0.1 4200 /dev/spidev0.0 4 3000 &>/var/log/leds.log &
        chrt -f -p 99 $!
fi

# restart after 10s upon crash, just in case :)
sleep 10

done

