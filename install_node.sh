#!/bin/bash

# we install nodejs v10 and some packages

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

# apt-get install -y nodejs build-essential
apt-get install -y nodejs

npm -g install express ws socket.io body-parser #mdns

