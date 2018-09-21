#!/bin/bash

# This is the launcher for the closed-source version of our software...
# for TheBigLEDowSPI, you should keep using the older launch.sh script

if [ ! -x /usr/bin/nodejs ]; then
	exit 0
fi

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPTPATH

MAC=`sed 's/://g' /sys/class/net/eth0/address`

export NODE_PATH=/usr/lib/node_modules

while [ 1 ]; do

        zps=`pgrep -fc server.js`
        #/usr/bin/nodejs server.js config.json &>/var/log/ledctrl.log &
        if [ $zps -lt 1 ] ; then
                                /usr/bin/nodejs server.js config.json &>/var/log/ledctrl.log &
        fi

        sleep 2

        zps=`pgrep -fc controller.js`
        #/usr/bin/nodejs controller.js $MAC ctrl.json &>/var/log/ledclt.log &
        if [ $zps -lt 1 ] ; then
                                /usr/bin/nodejs controller.js $MAC ctrl.json &>/var/log/ledclt.log &
        			chrt -f -p 99 $!
        fi

        # restart after 10s upon crash, just in case :)
        sleep 10

done

