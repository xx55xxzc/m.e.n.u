#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi

MYIP=$(wget -qO- ipv4.icanhazip.com)
# go to root
cd
disable-user-expire
clear

echo "------------------ DAFTAR AKUN SSH EXPIRED ------------------"
echo ""

cat /root/expireduser.txt | boxes -d columns | lolcat
echo ""
