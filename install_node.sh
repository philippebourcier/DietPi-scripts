#!/bin/bash

# we install nodejs v10 and some packages

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

apt-get install -y nodejs build-essential

npm -g install express socket.io body-parser 

