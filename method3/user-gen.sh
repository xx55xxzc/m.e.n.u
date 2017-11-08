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

echo "------------------ CREATE AKUN TRIAL -------------------
<<<<<<<<<<  UNDER AUTHORITY   : DG-Network™  >>>>>>>>>>" | lolcat

echo ""

read -p "Berapa hari akun aktif: " AKTIF

	uname=trial-`</dev/urandom tr -dc X-Z0-9 | head -c4`
	masaaktif="$AKTIF"
	pass=`</dev/urandom tr -dc a-f0-9 | head -c9`
	clear

clear
echo -e ""| lolcat
echo -e ""| lolcat
echo -e ""| lolcat
echo -e ""| lolcat
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $uname
exp="$(chage -l $uname | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$pass\n$pass\n"|passwd $uname &> /dev/null
echo -e ""| lolcat
echo -e "            |    Informasi Akun Trial    |
       ===========-[[SERVER-PREMIUM]]-============
            Host: $MYIP
            Username: $uname
            Password: $pass
            Aktif Sampai: $exp
            Port Default Dropbear: 443,80
            Port Default OpenSSH : 22,143
            Port Default Squid   : 8080,3128

                     Config OpenVPN:
          http://$MYIP:81/client.ovpn

            Auto kill user maximal login 2
       -------------------------------------------
       ===========================================
             UNDER AUTHORITY   : Fluxo-7™		
       ===========================================
       ===========================================" | boxes -d nuke | lolcat
echo -e ""
echo -e ""
