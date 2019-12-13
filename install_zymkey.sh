#!/bin/bash

cd /root

apt -y install build-essential
apt -y install python3 python3-pip python-pip
pip install wheel
pip3 install wheel

wget https://s3.amazonaws.com/zk-sw-repo/install_zk_sw.sh
bash install_zk_sw.sh
