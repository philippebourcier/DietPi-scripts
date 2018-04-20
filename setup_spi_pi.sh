#!/bin/bash

# This script is launched only once, during DietPi automated installation.
# It automatically configures DietPi on a RasPi 3(B) to be used with TheBigLEDowSPI
# Allowing a RasPi to control 2 x 5000+ SPI (APA102/SK9822) LED arrays or strips at 25 FPS or more
# The less LEDs you have, the more FPS you get... below 25 FPS, your animation won't look good...
# but if you don't care (ie: no animation), you can drive tens of thousands of LEDs (on a single output).

# man... How can you live without Vim ?
# redundant with dietpi.txt config
#apt -y install vim

# if you are testing with the python script, you should uncomment the following line
#apt -y install pypy

# save power
sed -i 's/exit/\/usr\/bin\/tvservice -o\n\nexit/g' /etc/rc.local
# don't mess with the SPI hardware clock
sed -i 's/exit/echo "performance" > \/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_governor\n\nexit/g' /etc/rc.local

# set SPI HW buffer size to 20K (5120 APA102/SK9822 SPI LEDs... the maximum doable by the LEDs to keep FPS above 25)
sed -i '$ s/$/ spidev.bufsiz=20480/g' /boot/cmdline.txt
# disable serial console (UART) so we can enable SPI1
sed -i 's/console=serial0,115200 //g' /boot/cmdline.txt

# disable bad or useless things
cat << EOF > /etc/modprobe.d/raspi-blacklist.conf
## bt
blacklist btbcm
blacklist bluetooth
blacklist hci_uart
## wifi
blacklist cfg80211
blacklist ecdh_generic
## FW
blacklist ip_tables
blacklist x_tables
EOF

# disable BT+audio and enable SPI 0 and 1
echo /DietPi/config.txt /boot/config.txt | tr ' ' '\n' | while read thisfile; do
if [ -f $thisfile ]; then
sed -i 's/dtparam=spi=off/dtparam=spi=on/g' $thisfile
sed -i 's/dtparam=audio=on/dtparam=audio=off/g' $thisfile 
cat << EOF >> $thisfile
####### NEW (enable SPI1)
dtoverlay=pi3-disable-bt
enable_uart=0
dtparam=uart0=off
dtparam=uart1=off
dtoverlay=spi1-1cs
dtoverlay=spi0-hw-cs
EOF
fi
done

# things I hate
# Vim VISUAL WTF!
sed -i 's/  set mouse=a//g' /usr/share/vim/vim80/defaults.vim
# SCP broken by interactive script
echo /root/.bashrc /home/dietpi/.bashrc | tr ' ' '\n' | while read thisfile; do
cat << EOF > $thisfile
# ~/.bashrc: executed by bash(1) for non-login shells.
alias ll='ls $LS_OPTIONS -laF'
. /DietPi/dietpi/func/dietpi-globals
if [ -t 0 ]; then
        /DietPi/dietpi/login
fi
EOF

exit 0

