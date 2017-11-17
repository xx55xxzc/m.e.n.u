#!/bin/bash


# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;

if [[ -e /etc/debian_version ]]; then
	#OS=debian
	RCLOCAL='/etc/rc.local'
else
	echo "Sepertinya Anda tidak menjalankan installer ini pada sistem Debian"
	exit
fi

# go to root
cd

MYIP=$(wget -qO- ipv4.icanhazip.com);

clear
echo "------------------ OCS Panels Installer for Debian ------------------"

echo -e "\e[36m                 DEVELOPED BY CHANDRA989 / (0143749392)"
echo ""
echo ""
echo -e "\e[33mI need to ask some questions before starting setup "
echo "You can leave the default option and just hit enter if you agree with the choice"
echo ""
echo -e "\e[31mFirst I need to know the new password for user root MySQL:"
read -p "New Password: " -e -i vpn989 DatabasePass
echo ""
echo -e "\e[34mFinally, say the Database Name for OCS Panels"
echo -e "\e[31mPlease, use one word only, no special characters other than Underscore(_)"
read -p "Nama Database: " -e -i OCS_PANEL DatabaseName
echo ""
echo -e "\e[35mOkay, that's all I need. We are ready to setup your OCS Panels now"
read -n1 -r -p "Press any key to continue ..."
service nginx stop
service php5-fpm stop
service php5-cli stop
apt-get -y --purge remove nginx php5-fpm php5-cli
#apt-get update
apt-get update -y
apt-get install build-essential expect -y

apt-get install -y mysql-server

#mysql_secure_installation
so1=$(expect -c "
spawn mysql_secure_installation; sleep 3
expect \"\";  sleep 3; send \"\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect eof; ")
echo "$so1"
#\r
#Y
#pass
#pass
#Y
#Y
#Y
#Y

chown -R mysql:mysql /var/lib/mysql/
chmod -R 755 /var/lib/mysql/

apt-get install -y nginx php5 php5-fpm php5-cli php5-mysql php5-mcrypt
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
mv /etc/nginx/conf.d/vps.conf /etc/nginx/conf.d/vps.conf.backup
wget -O /etc/nginx/nginx.conf "http://vpn989.com/989/encrypt/nginx.conf"
wget -O /etc/nginx/conf.d/vps.conf "http://vpn989.com/989/encrypt/vps.conf"
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf

useradd -m vps
mkdir -p /home/vps/public_html
rm /home/vps/public_html/index.html
echo "<?php phpinfo() ?>" > /home/vps/public_html/info.php
chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html
service php5-fpm restart
service nginx restart

apt-get install git
cd /home/vps/public_html
git init
git remote add origin https://github.com/fluxo7/o.c.s.git 
git pull origin master

chmod 777 /home/vps/public_html/config
chmod 777 /home/vps/public_html/config/config.ini
chmod 777 /home/vps/public_html/config/route.ini

#mysql -u root -p
so2=$(expect -c "
spawn mysql -u root -p; sleep 3
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"CREATE DATABASE IF NOT EXISTS $DatabaseName;EXIT;\r\"
expect eof; ")
echo "$so2"
#pass
#CREATE DATABASE IF NOT EXISTS OCS_PANEL;EXIT;

chmod 777 /home/vps/public_html/config
chmod 777 /home/vps/public_html/config/config.ini
chmod 777 /home/vps/public_html/config/route.ini

clear
echo ""
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo ""
echo -e "\e[31mSekarang Buka Browser Anda, akses alamat http: // $ MYIP: 85 / dan lengkapkan Details OcsPanel seperti di bawah !"
echo "Database:"
echo "- Database Host: localhost"
echo "- Database Name: $DatabaseName"
echo "- Database User: root"
echo "- Database Pass: $DatabasePass"
echo ""
echo "Admin Login:"
echo "- Username: Set Sendiri"
echo "- Password Baru: Set Sendiri"
echo "- Masukkan Ulang Password Baru: Set Sendiri"
echo ""
echo -e "\e[34mKlik Install dan tunggu Sampai Ada Tulisan Sila Hapus Folder Installation , kemudian tutup Browser dan kembali ke sini (Putty) dan kemudian tekan [ENTER]! "

sleep 3
echo ""
read -p "Sekiranya langkah di atas telah dilakukan, sila tekan  [Enter] untuk Continue ... "
echo ""
read -p "Pastikan Step Di Atas Di Buat Dengan Benar , Sebab Install OcsPanel Hanya Boleh Di Buat Sekali Tuk Tiap Vps , Press [Enter] To Continue ... "
echo ""

sed -i '$ i\deb http://download.webmin.com/download/repository sarge contrib' /etc/apt/sources.list
sed -i '$ i\deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib' /etc/apt/sources.list
cd /root
wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
apt-get update
apt-get install -y webmin
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart

apt-get -y --force-yes -f install libxml-parser-perl

rm -R /home/vps/public_html/installation

cd
rm -f /root/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# info
clear
echo "=======================================================" | tee -a log-install.txt
echo "Please login OCS Panels at http://$MYIP:81/" | tee -a log-install.txt

echo "" | tee -a log-install.txt
echo "Log Instalasi --> /root/log-install.txt" | tee -a log-install.txt
#echo "" | tee -a log-install.txt
#echo "PLEASE REBOOT YOUR VPS !" | tee -a log-install.txt
echo "=======================================================" | tee -a log-install.txt
cd ~/
