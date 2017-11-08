#!/bin/bash
apt-get install openvpn -y
cp -a /usr/share/doc/openvpn/examples/easy-rsa /etc/openvpn/
cd /etc/openvpn/easy-rsa/2.0
source ./vars
./clean-all
./build-ca
./build-dh
./build-key-server server01
openvpn –genkey –secret keys/ta.key
cd /etc/openvpn
curl http://satria.asia/script/server.conf > server.conf
curl http://satria.asia/script/server-udp.conf > server-udp.conf
mkdir /etc/openvpn/keys
cp /etc/openvpn/easy-rsa/2.0/keys/{ca.crt,server01.crt,server01.key,dh1024.pem} /etc/openvpn/keys/
sed -i ‘s/#AUTOSTART=”all”/AUTOSTART=”all”/g’ /etc/default/openvpn
/etc/init.d/openvpn restart
echo “net.ipv4.ip_forward=1” > /etc/sysctl.d/forwarding.conf
sysctl -p /etc/sysctl.d/forwarding.conf
if [ $(ifconfig | cut -c 1-8 | sort | uniq -u | grep venet0 | grep -v venet0 = “venet0” ];then
iptables -t nat -I POSTROUTING -s 192.168.200.0/24 -o venet0 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o venet0 -j MASQUERADE
else
iptables -t nat -I POSTROUTING -s 192.168.200.0/24 -o eth0 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
fi
mkdir clientconfig
cp /etc/openvpn/easy-rsa/2.0/keys/{ca.crt,ta.key} clientconfig/
curl http://satria.asia/script/client-tcp.conf > /etc/openvpn/clientconfig/client-tcp.ovpn
curl http://satria.asia/script/client-udp.conf > /etc/openvpn/clientconfig/client-udp.ovpn
IP=$(wget -qO- ipv4.icanhazip.com)
sed -i “s|remote my-server-2 1194|remote $IP 1194|” /etc/openvpn/clientconfig/client-udp.ovpn
echo “<ca>” >> /etc/openvpn/clientconfig/client-udp.ovpn
cat /etc/openvpn/easy-rsa/2.0/keys/ca.crt >> /etc/openvpn/clientconfig/client-udp.ovpn
echo “</ca>” >> /etc/openvpn/clientconfig/client-udp.ovpn
sed -i “s|remote my-server-1 9090|$IP 9090|” /etc/openvpn/clientconfig/client-tcp.ovpn
echo “<ca>” >> /etc/openvpn/clientconfig/client-tcp.ovpn
cat /etc/openvpn/easy-rsa/2.0/keys/ca.crt >> /etc/openvpn/clientconfig/client-tcp.ovpn
echo “</ca>” >> /etc/openvpn/clientconfig/client-tcp.ovpn
apt-get install zip -y
cd /etc/openvpn/clientconfig/
zip VPN.zip *
cd
# setting iptables
iptables -t nat -L
iptables -L
iptables-save > /etc/iptables_yg_baru_dibikin.conf
cd /etc/network/if-up.d
curl http://satria.asia/script/iptables.txt > iptables
chmod +x /etc/network/if-up.d/iptables
# Move dorectory config
mv /etc/openvpn/clientconfig/VPN.zip /var/www/
echo “Download Config OpenVPN di http://$IP/VPN.zip