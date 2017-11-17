#!/bin/bash

# go to root
cd

# install mysql-server
apt-get update
apt-get -y install mysql-server
mysql_secure_installation
chown -R mysql:mysql /var/lib/mysql/
chmod -R 755 /var/lib/mysql/


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

# Install Nginx + PHP
apt-get -y install nginx php5 php5-fpm php5-cli php5-mysql php5-mcrypt
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
curl https://raw.githubusercontent.com/roymark/gutierrez/master/nginx.conf > /etc/nginx/nginx.conf
curl https://raw.githubusercontent.com/roymark/roymark.gutierrez/master/vps.conf > /etc/nginx/conf.d/vps.conf
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
useradd -m vps
mkdir -p /home/vps/public_html
echo "<?php phpinfo() ?>" > /home/vps/public_html/info.php
chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html
service php5-fpm restart
service nginx restart

# Install OCS Panels
apt-get -y install git
cd /home/vps/public_html
git init
git remote add origin https://github.com/leedzung-autoscrip/leeocs.git
git pull origin master
rm index.html

# Create Database
mysql -u root -p

chmod -R g+rw /home/vps/public_html
chown -R www-data:www-data /home/vps/public_html
chmod +x /home/vps/public_html
chmod -R 775 /var/lib/mysql/
chown -R mysql:mysql /var/lib/mysql/
chmod 777 /home/vps/public_html/config/route.ini
chmod 777 /home/vps/public_html/config/config.ini
chmod 777 /home/vps/public_html/config

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
echo -e "\e[31mSekarang Buka Browser Anda, akses alamat http: // $ MYIP: 989 / dan lengkapkan Details OcsPanel seperti di bawah !"
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

apt-get -y --force-yes -f install libxml-parser-perl

rm -R /home/vps/public_html/installation

cd
rm -f /root/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# info
clear
echo "=======================================================" | tee -a log-install.txt
echo "Please login OCS Panels at http://$MYIP:85/" | tee -a log-install.txt

echo "" | tee -a log-install.txt
echo "Log Instalasi --> /root/log-install.txt" | tee -a log-install.txt
#echo "" | tee -a log-install.txt
#echo "PLEASE REBOOT YOUR VPS !" | tee -a log-install.txt
echo "=======================================================" | tee -a log-install.txt
