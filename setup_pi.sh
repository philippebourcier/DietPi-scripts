#!/bin/bash

# This script is launched only once, during DietPi automated installation.

# that avahi thingy, ugly but practical...
wget -O/etc/avahi/avahi-daemon.conf https://raw.githubusercontent.com/philippebourcier/DietPi-scripts/master/avahi-daemon.conf

# disable serial console (UART) so we can enable SPI1
sed -i 's/console=serial0,115200 //g' /boot/cmdline.txt

# disable bad or useless things
cat << EOF > /etc/modprobe.d/raspi-blacklist.conf
## bt
blacklist btbcm
blacklist bluetooth
blacklist hci_uart
## sound
blacklist snd_bcm2835
## FW
blacklist ip_tables
blacklist x_tables
EOF

# things I hate
# Vim VISUAL WTF!
sed -i 's/  set mouse=a//g' /usr/share/vim/vim81/defaults.vim
# ll
echo "alias ll='ls $LS_OPTIONS -laF'" >> /root/.bashrc

# my pubkeys... you should use yours here :)
# if you don't want to contribute to the Internet of Shit, don't use passwords
my_keys="https://raw.githubusercontent.com/philippebourcier/pubkeys/master/authorized_keys"
mkdir /root/.ssh
mkdir /home/dietpi/.ssh
wget -O/root/.ssh/authorized_keys $my_keys
wget -O/home/dietpi/.ssh/authorized_keys $my_keys
chown -R dietpi:dietpi /home/dietpi/.ssh
sed -i 's/PermitRootLogin/#PermitRootLogin/g' /etc/ssh/sshd_config
echo -e "PasswordAuthentication no\nPermitRootLogin prohibit-password\n" >> /etc/ssh/sshd_config
service sshd restart

# update boot wait to 10s max
sed -i "/^CONFIG_BOOT_WAIT_FOR_NETWORK=/c CONFIG_BOOT_WAIT_FOR_NETWORK=0" /DietPi/dietpi.txt

exit 0
