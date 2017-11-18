#!/bin/bash

# go to root
cd


clear
echo "--------------------------------- OCS Panels Installer for Debian -------------------------------"
if [[ $vps = "zvur" ]]; then
	echo "                             ALL SUPPORTED BY: ZONA VPS UNTUK RAKYAT                             "
	echo "                     https://www.facebook.com/groups/Zona.VPS.Untuk.Rakyat/                      "
else
	echo "                                    ALL SUPPORTED BY ANEKA VPS                                   "
	echo "                               https://www.facebook.com/aneka.vps.us                             "
fi
echo "                    DEVELOPED BY YURI BHUANA (fb.com/youree82, 085815002021)                     "
echo ""
echo ""
echo "Saya perlu mengajukan beberapa pertanyaan sebelum memulai setup"
echo "Anda dapat membiarkan pilihan default dan hanya tekan enter jika Anda setuju dengan pilihan tersebut"
echo ""
echo "Pertama saya perlu tahu password baru user root MySQL:"
read -p "Password baru: " -e -i Qwerty123 DatabasePass
echo ""
echo "Terakhir, sebutkan Nama Database untuk OCS Panels"
echo "Tolong, gunakan satu kata saja, tidak ada karakter khusus selain Underscore (_)"
read -p "Nama Database: " -e -i OCS_PANEL DatabaseName
echo ""
echo "Oke, itu semua saya butuhkan. Kami siap untuk setup OCS Panels Anda sekarang"
read -n1 -r -p "Tekan sembarang tombol untuk melanjutkan..."

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
# install mysql-server
apt-get update
apt-get -y install mysql-server
mysql_secure_installation
chown -R mysql:mysql /var/lib/mysql/
chmod -R 755 /var/lib/mysql/

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
git remote add origin https://github.com/r38865/OCSPi.git
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



# info
clear
echo "Please go to http://ip-server:81/info.php"
echo "It is to check either the PHP is running"
