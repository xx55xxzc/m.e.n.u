#!/bin/bash
clear

myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;

flag=0

echo

function create_user() {
#myip=`dig +short myip.opendns.com @resolver1.opendns.com`
clear
echo -e ""| lolcat
echo -e ""| lolcat
echo -e ""| lolcat
echo -e ""| lolcat
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $uname
exp="$(chage -l $uname | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$pass\n$pass\n"|passwd $uname &> /dev/null
echo -e ""| lolcat
echo -e "|      Informasi Akun Baru SSH      |" | boxes -d dog | lolcat
echo -e "============-Fluxo7-============" | lolcat
echo -e "     Host: $myip" | lolcat
echo -e "     Username: $uname" | lolcat
echo -e "     Password: $pass                     " | lolcat
echo -e "     Port default dropbear: 443          " | lolcat
echo -e "     Port default openSSH : 22           " | lolcat
echo -e "     Port default squid   : 8080         " | lolcat
echo -e "     Port default openVPN : 55           " | lolcat
echo -e "     Auto kill user maximal login 2      " | lolcat
echo -e "-----------------------------------------" | lolcat
echo -e "     Aktif Sampai: $exp                  " | lolcat
echo -e "=========================================" | lolcat
echo -e "   DI LARANG:                            " | lolcat
echo -e "   HACKING-DDOS-PHISING-SPAM-TORENT      " | lolcat
echo -e "   Fluxo7   Fluxo7.               " | lolcat
echo -e "=========================================" | lolcat
echo -e "   Script by Fluxo7             " | lolcat
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
echo -e "   Config OVPN:                          " | lolcat
echo -e "   http://$myip:81/1194-client.ovpn      " | lolcat
echo -e "-----------------------------------------" | lolcat
echo -e ""
echo -e ""
}
function renew_user() {
	echo "Kadaluarsa User: $uname Di Perbarui Sampai: $expdate"| lolcat;
	usermod -e $expdate $uname
}

function delete_user(){
	userdel $uname
}

function expired_users(){
echo "                      _\|/_      "| lolcat
echo "                      (o o)      "| lolcat
echo "-------------------o00-{_}-00o---"| lolcat
echo "BIL  USERNAME          EXPIRED "| lolcat
echo "---------------------------------"| lolcat
count=1
	cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
	totalaccounts=`cat /tmp/expirelist.txt | wc -l`
	for((i=1; i<=$totalaccounts; i++ )); do
	tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
		username=`echo $tuserval | cut -f1 -d:`
		userexp=`echo $tuserval | cut -f2 -d:`
		userexpireinseconds=$(( $userexp * 86400 ))
		todaystime=`date +%s`
		expired="$(chage -l $username | grep "Account expires" | awk -F": " '{print $2}')"
		if [ $userexpireinseconds -lt $todaystime ] ; then
			printf "%-4s %-15s %-10s %-3s\n" "$count." "$username" "$expired"
			count=$((count+1))
		fi
	done
	rm /tmp/expirelist.txt
}

function not_expired_users(){
    cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
    totalaccounts=`cat /tmp/expirelist.txt | wc -l`
    for((i=1; i<=$totalaccounts; i++ )); do
        tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
        username=`echo $tuserval | cut -f1 -d:`
        userexp=`echo $tuserval | cut -f2 -d:`
        userexpireinseconds=$(( $userexp * 86400 ))
        todaystime=`date +%s`
        if [ $userexpireinseconds -gt $todaystime ] ; then
            echo $username
        fi
    done
	rm /tmp/expirelist.txt
}

function monssh2(){
echo ""| lolcat
echo "|   Tgl-Jam    | PID   |   User Name  |      Dari IP      |"| boxes -d peek | lolcat
echo "-------------------------------------------------------------"| lolcat
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);

echo "=================[ Checking Dropbear login ]================="| lolcat
echo "-------------------------------------------------------------"| lolcat
for PID in "${data[@]}"
do
	#echo "check $PID";
	NUM=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
	USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk -F" " '{print $10}'`;
	IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk -F" " '{print $12}'`;
	waktu=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk -F" " '{print $1,$2,$3}'`;
	if [ $NUM -eq 1 ]; then
		echo "$waktu - $PID - $USER - $IP"| lolcat;
	fi
done


echo "-------------------------------------------------------------"| lolcat
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

echo "==================[ Checking OpenSSH login ]================="| lolcat
echo "-------------------------------------------------------------"| lolcat
for PID in "${data[@]}"
do
        #echo "check $PID";
		NUM=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
		USER=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}'`;
		IP=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $11}'`;
		waktu=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $1,$2,$3}'`;
        if [ $NUM -eq 1 ]; then
                echo "$waktu - $PID - $USER - $IP"| lolcat;
        fi
done

echo "-------------------------------------------------------------"| lolcat
echo -e "==============[ User Monitor Dropbear & OpenSSH]============="| lolcat
}

function used_data(){
	myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`
	myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`
	ifconfig $myint | grep "RX bytes" | sed -e 's/ *RX [a-z:0-9]*/Received: /g' | sed -e 's/TX [a-z:0-9]*/\nTransfered: /g'
}

function bench-network2(){
wget freevps.us/downloads/bench.sh -O - -o /dev/null|bash
echo -e "Sekian...!!!"| lolcat
}

function user-list(){
echo "--------------------------------------------------"| lolcat
echo "BIL  USERNAME        STATUS       EXP DATE   "| lolcat
echo "--------------------------------------------------"| lolcat
C=1
ON=0
OFF=0
while read mumetndase
do
        USER="$(echo $mumetndase | cut -d: -f1)"
        ID="$(echo $mumetndase | grep -v nobody | cut -d: -f3)"
        EXP="$(chage -l $USER | grep "Account expires" | awk -F": " '{print $2}')"
        ONLINE="$(cat /etc/openvpn/log.log | grep -Eom 1 $USER | grep -Eom 1 $USER)"
        if [[ $ID -ge 500 ]]; then
        if [[ -z $ONLINE ]]; then
        printf "%-4s %-15s %-10s %-3s\n" "$C." "$USER" "OFFLINE" "$EXP"
        OFF=$((OFF+1))
        else
        printf "%-4s %-15s %-10s %-3s\n" "$C." "$USER" "ONLINE" "$EXP"
        ON=$((ON+1))
        fi
        C=$((C+1))
        fi
JUMLAH="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
done < /etc/passwd
echo "--------------------------------------------------"| lolcat
echo " OFFLINE : $OFF     ONLINE : $ON     TOTAL USER : $JUMLAH "| lolcat
echo "--------------------------------------------------"| lolcat
}

function lokasi(){

data=( `ps aux | grep -i dropbear | awk '{print $2}'`);

echo "User Login" | boxes -d peek | lolcat;
echo "=================================";
echo "Dropbear" | lolcat
for PID in "${data[@]}"
do
    #echo "check $PID";
    NUM=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
    USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $10}'`;
    IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $12}'`;
    if [ $NUM -eq 1 ]; then
        echo "$USER - $IP";
    fi
done
echo ""
echo "OpenSSH" | lolcat;

data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);


for PID in "${data[@]}"
do
        #echo "check $PID";
        NUM=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
        USER=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}'`;
        IP=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $11}'`;
        if [ $NUM -eq 1 ]; then
                echo "$USER - $IP";
        fi
done
echo "-------------------------------" | lolcat
}



clear
echo ""
echo ""
echo ""
echo "" | lolcat
echo "" | lolcat
echo "" | lolcat
echo "" | lolcat
echo "            ----[SELAMAT DATANG DI VPS Fluxo7  - ]---"| boxes -d dog | lolcat
echo "        ====================================================="| lolcat
echo "        #           WhatsApp     : +601094754543            #"| lolcat
echo "        #           Telegram     : @Fluxo7                  #"| lolcat
echo "        #           Channel      : @NewPremiumService       #"| lolcat
echo "        #           InstaGram    : Fluxo7                   #"| lolcat
echo "        #===================================================#"| lolcat
echo "        #         Copyright: © Fluxo7™ Premium 2017         #"| lolcat
echo "        ====================================================="| lolcat
echo -e "\e[40;38;5;101m                 WELCOME TO FLUXO7 VPS "
PS3='Silahkan ketik nomor pilihan anda lalu tekan ENTER: '
options=("Buat User Premium" "Buat ID Trial" "Perbarui User" "Semua User" "Padam User" "Monitor User Login" "Auto Kill Multi Login" "Stop Kill Multi Login" "User Belum Expired" "User Sudah Expired" "Restart Server" "Ganti Password User" "Ganti Password VPS" "Used Data By Users" "bench-network" "Ram Status" "Bersihkan cache ram" "Ganti Port OpenVPN" "Ganti Port Dropbear" "Ganti Port Openssh" "Ganti Port Squid3" "Speedtest" "Edit Banner Login" "Lihat Lokasi User" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Buat User")
       read -p "Enter username: " uname
       read -p "Enter password: " pass
       read -p "Kadaluarsa (Berapa Hari): " masaaktif
       clear
       create_user
	    break
            ;;
	"Buat User Trial")
	uname=trial-`</dev/urandom tr -dc 0-9 | head -c1`
	masaaktif="1"
	pass=`</dev/urandom tr -dc 0-9 | head -c5`
	clear
	create_user
	break
	;;
        "Perbarui User")
            read -p "Enter username yg di perbarui: " uname
            read -p "Aktif sampai tanggal Thn-Bln-Hr(YYYY-MM-DD): " expdate
            renew_user | boxes -d dog | lolcat
            break
            ;;
	 "Semua User")
	    user-list
	    break
	    ;;
        "Hapus User")
	    user-list
	    echo ""
            read -p "Ketik user (di atas) yang akan di hapus: " uname 
	    echo -e "User $uname sukses dihapus boss!!!" | boxes -d boy | lolcat
            delete_user
	    break
            ;;
	  "Monitor User Login")
	  monssh2
	  break
	  ;;
	    "Aktifkan Kill Multi Login")
	   #echo "@reboot root /root/userlimit.sh" > /etc/cron.d/userlimitreboot
	   echo "* * * * * root ./userlimit.sh 2" > /etc/cron.d/userlimit1
	   echo "* * * * * root sleep 10; ./userlimit.sh 2" > /etc/cron.d/userlimit2
           echo "* * * * * root sleep 20; ./userlimit.sh 2" > /etc/cron.d/userlimit3
           echo "* * * * * root sleep 30; ./userlimit.sh 2" > /etc/cron.d/userlimit4
           echo "* * * * * root sleep 40; ./userlimit.sh 2" > /etc/cron.d/userlimit5
           echo "* * * * * root sleep 50; ./userlimit.sh 2" > /etc/cron.d/userlimit6
	   e#cho "@reboot root /root/userlimitssh.sh" >> /etc/cron.d/userlimitreboot
	   echo "* * * * * root ./userlimitssh.sh 2" >> /etc/cron.d/userlimit1
	   echo "* * * * * root sleep 11; ./userlimitssh.sh 2" >> /etc/cron.d/userlimit2
           echo "* * * * * root sleep 21; ./userlimitssh.sh 2" >> /etc/cron.d/userlimit3
           echo "* * * * * root sleep 31; ./userlimitssh.sh 2" >> /etc/cron.d/userlimit4
           echo "* * * * * root sleep 41; ./userlimitssh.sh 2" >> /etc/cron.d/userlimit5
           echo "* * * * * root sleep 51; ./userlimitssh.sh 2" >> /etc/cron.d/userlimit6
	    service cron restart
	    service ssh restart
	    service dropbear restart
	    echo "------------+ AUTO KILL SUDAH DI AKTIFKAN BOSS +--------------" | lolcat
	    
	echo "Dasar pelit!!! user anda marah2 jangan salahkan saya ya boss
	nanti jangan lupa di matikan boss" | boxes -d boy | lolcat
		break
		;;
	"Matikan Kill Multi Login")
	rm -rf /etc/cron.d/userlimit1
	rm -rf /etc/cron.d/userlimit2
	rm -rf /etc/cron.d/userlimit3
	rm -rf /etc/cron.d/userlimit4
	rm -rf /etc/cron.d/userlimit5
	rm -rf /etc/cron.d/userlimit6
	rm -rf /etc/cron.d/userlimitreboot
	service cron restart
	    service ssh restart
	    service dropbear restart
	echo "AUTO KILL LOGIN,SUDAH SAYA MATIKAN BOS!!!" | boxes -d boy | lolcat
	break
	;;
		"User Belum Kadaluarsa")
			not_expired_users | boxes -d dog | lolcat
			break
			;;
		"User Sudah Kadaluarsa")
			expired_users | boxes -d dog | lolcat
			break
			;;		
		"Restart Server")
			reboot
			break
			;;
		"Ganti Password User")
		read -p "Ketik user yang akan di ganti passwordnya: " uname
		read -p "Silahkan isi passwordnya: " pass
		echo "$uname:$pass" | chpasswd
		echo "Mantaffff boss!!! Password $uname user anda sudah di ganti..."| boxes -d peek | lolcat
		break
		;;
		"Ganti Password VPS")
		read -p "Silahkan isi password baru untuk VPS anda: " pass	
		echo "root:$pass" | chpasswd
		echo "Ciieeee.. ciieeeeeee.. abis ganti password VPS ni yeeee...!!!"| boxes -d boy | lolcat
			break
			;;
		"Used Data By Users")
			used_data | boxes -d boy | lolcat
 			break
			;;
		"bench-network")
			bench-network2 | lolcat
			break
			;;
		"Ram Status")
			free -h | grep -v + > /tmp/ramcache
			cat /tmp/ramcache | grep -v "Swap"
			break
			;;
		"Bersihkan cache ram")
	                echo 3 > /proc/sys/vm/drop_caches && swapoff -a && swapon -a
			echo "SUKSES..!!!Cache ram anda sudah di bersihkan." | boxes -d spring | lolcat
		        break
			;;
		"Ganti Port OpenVPN")	
            echo "Silahkan ganti port OpenVPN anda lalu klik enter?"| boxes -d peek | lolcat
            read -p "Port: " -e -i 55 PORT
	    service dropbear stop
	    service ssh stop
	    service openvpn stop
            sed -i "s/port [0-9]*/port $PORT/" /etc/openvpn/1194.conf
	    cp /etc/openvpn/1194-client.ovpn /home/vps/public_html/1194-client.ovpn
            sed -i "s/ipserver ports/$myip $PORT/g" /home/vps/public_html/1194-client.ovpn
	    sed -i "s/ipserver/$myip/g" /home/vps/public_html/1194-client.ovpn
	   service openvpn start
	    service dropbear start
	    service ssh start
            echo "OpenVPN Updated Port: $PORT"| lolcat
			break
			;;
		"Ganti Port Dropbear")	
            echo "Silahkan ganti port Dropbear anda lalu klik ENTER!!!
Port dropbear tidak boleh sama dengan port openVPN/openSSH/squid3 !!!"| boxes -d peek | lolcat
           echo "Port1: 443 (Default)"
	    read -p "Port2: " -e -i 109 PORT
	    #read -p "Port3: " -e -i 143 PORT3
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
	   "Ganti Port Openssh")	
            echo "Silahkan ganti port Openssh anda lalu klik enter."| boxes -d peek | lolcat
            echo "Port default dan Port 2 tidak boleh sama !!!"| lolcat
	    echo "Port default: 22"| lolcat
	    read -p "Port 2: " -e -i 80 PORT
	    service dropbear stop
	    service ssh stop
	    service openvpn stop
	    sed -i "s/Port  [0-9]*\nPort [0-9]*/Port  22\nPort $PORT/g" /etc/ssh/sshd_config
           service ssh start
	   service dropbear start
	   service openvpn start
            echo "Openssh Updated Port: $PORT"| lolcat
			break
			;;
        "Ganti Port Squid3")	
            echo "Silahkan ganti port Squid3 anda lalu klik enter"| boxes -d dog | lolcat
	    echo "Isi dengan angka tidak boleh huruf !!!"| lolcat
	    read -p "Port Squid3: " -e -i 8080 PORT
            #sed -i 's/http_port [0-9]*\nhttp_port [0-9]*/http_port $PORT1\nhttp_port $PORT2/g' /etc/squid3/squid.conf
            sed -i "s/http_port [0-9]*/http_port $PORT/" /etc/squid3/squid.conf
	   service squid3 restart
            echo "Squid3 Updated Port: $PORT"| lolcat
			break
			;;
			"Speedtest")
			python speedtest.py --share | lolcat
			break		
			;;
	"Edit Banner Login")
	echo -e "1. Simpan text (CTRL + X, lalu ketik Y dan tekan Enter)
2. Membatalkan edit text (CTRL + X, lalu ketik N dan tekan Enter)" | boxes -d boy | lolcat
	read -p "Tekan ENTER untuk melanjutkan........................ " | lolcat
	nano /bannerssh
	service ssh restart &&  service dropbear restart
	break
	;;
	"Lihat Lokasi User")
	lokasi
read -p "Ketik Salah Satu Alamat IP User: " userip
curl ipinfo.io/$userip
break
;;
		"Quit")
		
		break
		;;
	 
        *) echo invalid option;
	esac
done
