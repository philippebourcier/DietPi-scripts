#!/bin/bash

# Zymkey + LUKS on DietPi
cd /root/

# get the zymkey script
wget https://s3.amazonaws.com/zk-sw-repo/mk_encr_ext_rfs.sh

# copy config.txt to /DietPi/
sed -i 's/>> \/mnt\/tmpboot\/config.txt/& \&\& \/bin\/cp -f \/mnt\/tmpboot\/config.txt \/DietPi\//g' mk_encr_ext_rfs.sh

# Fix NIC names issue
sed -i 's/" >> \/mnt\/tmpboot\/cmdline.txt/ net.ifnames=0&/g' mk_encr_ext_rfs.sh

# LUKS conversion
bash ./mk_encr_ext_rfs.sh -s "+8G"
