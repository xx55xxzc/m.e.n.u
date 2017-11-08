#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi

# get the VPS IP
#ip=`ifconfig venet0:0 | grep 'inet addr' | awk {'print $2'} | sed s/.*://`
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
#MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
if [ "$MYIP" = "" ]; then
	MYIP=$(wget -qO- ipv4.icanhazip.com)
fi
#MYIP=$(wget -qO- ipv4.icanhazip.com)


echo "------------------------ MEMBUAT AKUN SSH ------------------------"| lolcat


echo "<<<<<<<<<<  UNDER AUTHORITY   : DG-Network™  >>>>>>>>>>" | lolcat
echo ""

read -p "Isikan username: " username

egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
	echo "Username [$username] sudah ada!"
	exit 1
else
	read -p "Isikan password akun [$username]: " password
	read -p "Berapa hari akun [$username] aktif: " AKTIF

	today="$(date +"%Y-%m-%d")"
	expire=$(date -d "$AKTIF days" +"%Y-%m-%d")
	useradd -M -N -s /bin/false -e $expire $username
	echo $username:$password | chpasswd
clear
echo -e ""
echo -e ""
echo -e ""
echo -e ""| lolcat
echo -e "              |  Informasi Akun Baru SSH  |
       ============[[-SERVER-PREMIUM-]]===========
            Host: $MYIP
            Username: $username
            Password: $password
            Port Default Dropbear: 443,80
            Port Default OpenSSH : 22,143
            Port Default Squid   : 8080,3128

                    Config OpenVPN:
          http://$MYIP:81/client.ovpn
 
             Auto kill user maximal login 2
       -------------------------------------------
       ===========================================
            UNDER AUTHORITY     : Fluxo-7
       ===========================================
       ===========================================" | boxes -d nuke | lolcat
echo -e ""
echo -e ""
fi


