#!/bin/bash
clear

# get the VPS IP
#ip=`ifconfig venet0:0 | grep 'inet addr' | awk {'print $2'} | sed s/.*://`
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
#MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
if [ "$MYIP" = "" ]; then
	MYIP=$(wget -qO- ipv4.icanhazip.com)
fi
#myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;

flag=0

echo

	#MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
	#if [ "$MYIP" = "" ]; then
		#MYIP=$(wget -qO- ipv4.icanhazip.com)
	#fi
lolcat -F 0.3 -S 0 /usr/bin/bannermenu
echo "                          Server: $MYIP" | lolcat
date +"                          %A, %d-%m-%Y" | lolcat
date +"                                  %H:%M:%S %Z" | lolcat
echo""
echo""
echo -e "\e[40;38;5;101m                           SIMPLE MENU"
PS3='Silahkan ketik nomor pilihan anda kemudian tekan ENTER: '
options=("Create Akun SSH/OVPN" "Create Akun Trial" "Perbarui User" "Ganti Password User SSH/OVPN" "Semua User Dan Tanggal Kadaluarsa" "Hapus User" "Monitoring User Dan Tendang" "Monitor User Login" "Daftar User Aktif" "Daftar User Kadaluarsa" "Disable User Kadaluarsa" "Hapus User Kadaluarsa" "Banned User" "Unbanned User" "Informasi RAM" "Speedtest" "Benchmark" "Manual Kill Multi Login" "Auto Kill Multi Login" "Ganti Password VPS" "Bersihkan Cache Ram Manual" "Edit Banner SSH" "Edit Banner Menu" "Restart Webmin" "Restart VPS" "Restart Dropbear" "Restart OpenSSH" "Restart Squid" "Restart OpenVPN" "Ganti Port OpenSSH" "Ganti Port Dropbear" "Ganti Port Squid" "Ganti Port OpenVPN" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Buat User SSH/OVPN")
	clear
        user-add
        break
            ;;
	"Buat User SSH/OVPN Trial")
	clear
	user-gen
	break
	;;
	"Perbarui User")
	clear
	user-renew
	break
	;;
	"Ganti Password User SSH/OVPN")
	clear
	user-pass
	break
	;;
	"Semua User Dan Tanggal Kadaluarsa")
	clear
	user-list | lolcat
	break
	;;
	"Hapus User")
	clear
	user-del
	break
	;;
	"Monitoring User Dan Tendang")
	clear
	dropmon
	break
	;;
	"Monitor User Login")
	clear
	user-login
	break
	;;
	"Manual Kill Multi Login")
	clear
        read -p "Isikan Maximal User Login (1-2): " MULTILOGIN
        userlimit.sh $MULTILOGIN
	userlimitssh.sh $MULTILOGIN
	break
	;;
	"Auto Kill Multi Login")
	clear 
	read -p "Isikan Maximal User Login (1-2): " MULTILOGIN2
	#echo "@reboot root /root/userlimit.sh" > /etc/cron.d/userlimitreboot
	echo "* * * * * root /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit1
	   echo "* * * * * root sleep 10; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit2
           echo "* * * * * root sleep 20; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit3
           echo "* * * * * root sleep 30; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit4
           echo "* * * * * root sleep 40; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit5
           echo "* * * * * root sleep 50; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit6
	   #echo "@reboot root /root/userlimitssh.sh" >> /etc/cron.d/userlimitreboot
	   echo "* * * * * root /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit1
	   echo "* * * * * root sleep 11; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit2
           echo "* * * * * root sleep 21; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit3
           echo "* * * * * root sleep 31; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit4
           echo "* * * * * root sleep 41; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit5
           echo "* * * * * root sleep 51; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit6
	    service cron restart
	    service ssh restart
	    service dropbear restart
	    echo "------------+ AUTO KILL MULTI LOGIN SUDAH DI AKTIFKAN +--------------" | lolcat
	    
	echo "Apabila user-user mengeluh/protes,
Anda bisa setting secara manual pada menu MANUAL KILL MULTI LOGIN" | boxes -d boy | lolcat
	break
	;;
	"Bersihkan Cache Ram Manual")
	clear
	echo "Cleaning..." | lolcat
       free -h
	echo 1 > /proc/sys/vm/drop_caches
	sleep 1
	echo 2 > /proc/sys/vm/drop_caches
	sleep 1
	echo 3 > /proc/sys/vm/drop_caches && swapoff -a && swapon -a
	sleep 1
	echo ""
	echo "Finishing..." | lolcat
	free -h
	echo "DONE....!!!Cache RAM sudah bersih." | boxes -d boy | lolcat
        break
	;;
	"Daftar User Aktif")
	clear
	user-active-list | boxes -d dog | lolcat
	break
	;;
	"Daftar User Kadaluarsa")
	clear
	user-expire-list | lolcat
	break
	;;
	"Disable User Kadaluarsa")
	clear
	disable-user-expire
	break
	;;
	"Hapus User Kadaluarsa")
	clear
	delete-user-expire
	break
	;;
	"Banned User")
	clear
	banned-user
	break
	;;
	"Unbanned User")
	clear
	unbanned-user
	break
	;;
	"Informasi RAM")
	clear
	ps-mem | boxes -d dog | lolcat
	break
	;;
	"Speedtest")
	clear
	echo "SPEEDTEST SERVER" | boxes -d peek | lolcat
	echo "-----------------------------------------"
	speedtest --share | lolcat
	echo "-----------------------------------------"
	break
	;;
	"Benchmark")
	clear
	echo "BENCHMARK" | boxes -d peek | lolcat
	benchmark | lolcat
	break
	;;
        "Edit Banner SSH")
	clear
	echo "-----------------------------------------------------------" | lolcat
	echo -e "1.) Simpan text (CTRL + X, lalu ketik Y dan tekan Enter) " | lolcat
	echo -e "2.) Membatalkan edit text (CTRL + X, lalu ketik N dan tekan Enter)" | lolcat
	echo "-----------------------------------------------------------" | lolcat
	read -p "Tekan ENTER untuk melanjutkan........................ " | lolcat
	nano /bannerssh
	service dropbear restart && service ssh restart
	break
	;;
	"Edit Banner Menu")
	clear
	echo "--------------------------------------------------------" | lolcat
	echo -e "1. Simpan text (CTRL + X, lalu ketik Y dan tekan ENTER)" | lolcat
	echo -e "2. Membatalkan edit text (CTRL + X,lalu ketik N dan tekan ENTER)" | lolcat
	echo "--------------------------------------------------------" | lolcat
	read -p "Tekan ENTER untuk melanjutkan..................." | lolcat
	nano /usr/bin/bannermenu
	break
	 ;;
	 "Restart VPS")
	 clear
	 reboot
	 echo "The VPS has beesn RESTARTED!!!
SERVER will be going DOWN :D" | boxes -d boy | lolcat
	 break
	 ;;
	 "Restart Dropbear")
	 clear
	 service dropbear restart
	 echo "DROPBEAR has beesn RESTARTED!!!" | boxes -d boy | lolcat
	 break
	 ;;
	 "Restart OpenSSH")
	 clear
	 service ssh restart
	 echo "OpenSSH has beesn RESTARTED!!!" | boxes -d boy | lolcat
	 break
	 ;;
	 "Restart OpenVPN")
	 clear
	 service openvpn restart
	 echo "OpenVPN has beesn RESTARTED!!!" | boxes -d boy | lolcat
	 break
	 ;;
	 "Restart Squid")
	 clear
	 service squid3 restart
	 echo "SQUID PROXY has beesn RESTARTED!!!" | boxes -d boy | lolcat
	 break
	 ;;
	 "Ganti Port OpenSSH")
	 clear
            echo "Silahkan ganti port Openssh anda lalu klik enter."| boxes -d peek | lolcat
            echo "Port default dan Port 2 tidak boleh sama !!!"| lolcat
	    echo "Port default: 22"| lolcat
	    read -p "Port 2: " -e -i 143 PORT
	    service dropbear stop
	    service ssh stop
	    service openvpn stop
	    sed -i "6s/Port [0-9]*/Port $PORT/" /etc/ssh/sshd_config
           service ssh start 
	   service dropbear start
	   service openvpn start
            echo "Openssh Updated Port: $PORT"| lolcat
	 break
         ;;
	 "Ganti Port Dropbear")
	 clear
            echo "Silahkan ganti port Dropbear anda lalu klik ENTER!!!
Port dropbear tidak boleh sama dengan port openVPN/openSSH/squid3 !!!"| boxes -d peek | lolcat
           echo "Port1: 443 (Default)"
	    read -p "Port2: " -e -i 80 PORT
	    service dropbear stop
	    service ssh stop
	    service openvpn stop
            sed -i "s/DROPBEAR_PORT=[0-9]*/DROPBEAR_PORT=$PORT/g" /etc/default/dropbear
	    #sed -i 's/DROPBEAR_EXTRA_ARGS="-p [0-9]*"/DROPBEAR_EXTRA_ARGS="-p 109"/g' /etc/default/dropbear	
            service dropbear start
	    service ssh start
	    service openvpn start
            echo "Dropbear Updated Port2 : $PORT"| lolcat
	    #echo "Dropbear Updated : Port2 $PORT2" | lolcat
	    #echo "Dropbear Updated : Port3 $PORT3" | lolcat
	 break
	 ;;
	 "Ganti Port Squid")
	 clear
	 echo "Silahkan ganti port Squid3 anda lalu klik enter"| boxes -d dog | lolcat
	    echo "Isi dengan angka tidak boleh huruf !!!"| lolcat
	    echo -e "Port Squid3 1: 8080"
	    read -p "Port Squid3 2: " -e -i 3128 PORT
            #sed -i 's/http_port [0-9]*\nhttp_port [0-9]*/http_port $PORT1\nhttp_port $PORT2/g' /etc/squid3/squid.conf
            sed -i "23s/http_port [0-9]*/http_port $PORT/" /etc/squid3/squid.conf
	   service squid3 restart
            echo "Squid3 Updated Port: $PORT"| lolcat
			break
			;;
			"Speedtest")
			clear
			python speedtest.py --share | lolcat
			break		
	 ;;
	 "Ganti Port OpenVPN")
	 clear
	           echo "Silahkan ganti port OpenVPN anda lalu klik enter?"| boxes -d peek | lolcat
            read -p "Port: " -e -i 55 PORT
	    service dropbear stop
	    service ssh stop
	    service openvpn stop
            sed -i "s/port [0-9]*/port $PORT/" /etc/openvpn/server.conf
	    cp /etc/openvpn/client.ovpn /home/vps/public_html/client.ovpn
            sed -i "s/ipserver ports/$MYIP $PORT/g" /home/vps/public_html/client.ovpn
	    sed -i "s/ipserver/$MYIP/g" /home/vps/public_html/client.ovpn
	   service openvpn start
	    service dropbear start
	    service ssh start
	 break
	 ;;
	 
	"Quit")
	
	break
	;;
	 
        *) echo Unknown Option, Please Try Again!!!;
	esac
done
