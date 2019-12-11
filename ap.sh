#!/bin/bash

cat << EOF > /etc/dhcp/dhcpd.conf
ddns-update-style none;
default-lease-time 600;
max-lease-time 7200;
authoritative;
log-facility local7;
subnet 192.168.42.0 netmask 255.255.255.0 {
        range 192.168.42.10 192.168.42.50;
        option broadcast-address 192.168.42.255;
        option routers 192.168.42.1;
        option domain-name "local";
        option domain-name-servers 192.168.42.1;
}
EOF

MAC=`sed 's/://g' /sys/class/net/eth0/address | rev`
SSID=`sed 's/://g' /sys/class/net/eth0/address | cut -c9- | tr 'a-z' 'A-Z'`

cat << EOF | sed "s/zMAC/$MAC/g" | sed "s/zSSID/LED_Skipper_$SSID/g" > /etc/hostapd/hostapd.conf
interface=wlan0
driver=nl80211
ssid=zSSID
hw_mode=g
channel=13
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=zMAC
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
ieee80211n=1
EOF
