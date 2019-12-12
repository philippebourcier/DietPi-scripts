#!/bin/bash

/DietPi/dietpi/func/dietpi-set_hardware i2c enable

apt -y install build-essential
apt -y install python3 python3-pip python-pip
pip install wheel
pip3 install wheel

curl -G https://s3.amazonaws.com/zk-sw-repo/install_zk_sw.sh | bash
