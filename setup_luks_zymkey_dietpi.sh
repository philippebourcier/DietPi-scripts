#!/bin/bash

# Zymkey + LUKS on DietPi
cd /root/

# get the zymkey script
wget https://s3.amazonaws.com/zk-sw-repo/mk_encr_ext_rfs.sh

# modify fdisk to hide LUKS partition from Windows but still create a visible vFAT partition
POSFDISK=`grep -n fdisk mk_encr_ext_rfs.sh | grep EXT_DEV | cut -f1 -d":"`
OFDISK=`grep fdisk mk_encr_ext_rfs.sh | grep EXT_DEV | awk '{ print $3 }'`
NFDISK='"n\np\n2\n\n+1G\n\nn\ne\n${RFS_DST_PART_NUM}\n\n${MAX_RFS_SIZE}\n\nt\n2\ne\nw\n"'
sed -i "s/${OFDISK//\\n/\\\\n}/${NFDISK//\\n/\\\\n}/g" mk_encr_ext_rfs.sh
sed -i "${POSFDISK}imkfs.vfat /dev/sda2' mk_encr_ext_rfs.sh

# copy config.txt to /DietPi/
sed -i 's/>> \/mnt\/tmpboot\/config.txt/& \&\& \/bin\/cp -f \/mnt\/tmpboot\/config.txt \/DietPi\//g' mk_encr_ext_rfs.sh

# Fix NIC names issue
sed -i 's/" >> \/mnt\/tmpboot\/cmdline.txt/ net.ifnames=0&/g' mk_encr_ext_rfs.sh

# LUKS conversion
bash ./mk_encr_ext_rfs.sh -s "+8G"
