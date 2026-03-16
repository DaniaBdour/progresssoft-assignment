
----------------------------------------------------------------
1.1  SYSTEM UPDATE
----------------------------------------------------------------
sudo apt update
sudo apt upgrade -y
lsb_release -a
hostname
ip addr show
hostname -I
 
 
----------------------------------------------------------------
1.2  CREATE AND RUN sysinfo.sh
----------------------------------------------------------------
nano ~/sysinfo.sh
chmod +x ~/sysinfo.sh
./sysinfo.sh
bash ~/sysinfo.sh
cat ~/sysinfo.sh
ls -la ~/sysinfo.sh
 
---- sysinfo.sh FULL SCRIPT ----
#!/bin/bash
EXEC_USER=$(whoami)
HOSTNAME_VAL=$(hostname)
SERVER_IP=$(hostname -I | awk '{print $1}')
PUBLIC_IP=$(curl -s https://api.ipify.org 2>/dev/null || echo 'N/A')
OS=$(lsb_release -d | cut -f2)
KERNEL=$(uname -r)
ARCH=$(uname -m)
VIRT=$(systemd-detect-virt 2>/dev/null || echo 'unknown')
SERVER_TIME=$(date)
TIMEZONE=$(timedatectl | grep 'Time zone' | awk '{print $3}')
UPTIME_VAL=$(uptime -p | sed 's/up //')
TOTAL_MEM=$(free -h | awk '/^Mem:/ {print $2}')
USED_MEM=$(free -h  | awk '/^Mem:/ {print $3}')
SWAP_TOTAL=$(free -h | awk '/^Swap:/ {print $2}')
SWAP_USED=$(free -h  | awk '/^Swap:/ {print $3}')
CPU_CORES=$(nproc)
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_USED=$(df -h /  | awk 'NR==2 {print $3}')
DISK_FREE=$(df -h /  | awk 'NR==2 {print $4}')
NET_IF=$(ip route | awk '/default/ {print $5}')
GATEWAY=$(ip route | awk '/default/ {print $3}')
 
echo '================================================='
echo '         SYSTEM INFORMATION REPORT               '
echo '================================================='
echo "Executed By      : $EXEC_USER"
echo "Hostname         : $HOSTNAME_VAL"
echo "Local IP         : $SERVER_IP"
echo "Public IP        : $PUBLIC_IP"
echo "OS               : $OS"
echo "Kernel Version   : $KERNEL"
echo "Architecture     : $ARCH"
echo "Virtualisation   : $VIRT"
echo "Server Time      : $SERVER_TIME"
echo "Timezone         : $TIMEZONE"
echo "Uptime           : $UPTIME_VAL"
echo '-------------------------------------------------'
echo '         RESOURCE USAGE                          '
echo '-------------------------------------------------'
echo "Total RAM        : $TOTAL_MEM"
echo "Used RAM         : $USED_MEM / $TOTAL_MEM"
echo "Swap             : $SWAP_USED / $SWAP_TOTAL"
echo "CPU Cores        : $CPU_CORES"
echo "Disk Total       : $DISK_TOTAL"
echo "Disk Used        : $DISK_USED  Free: $DISK_FREE"
echo '-------------------------------------------------'
echo '         NETWORK                                 '
echo '-------------------------------------------------'
echo "Network Interface: $NET_IF"
echo "Default Gateway  : $GATEWAY"
echo '================================================='
---- END OF SCRIPT ----
 
 
----------------------------------------------------------------
1.3  CREATE USER PS
----------------------------------------------------------------
sudo groupadd PSgroup
sudo groupadd dba
grep 'PSgroup\|dba' /etc/group
sudo useradd -g PSgroup -G dba -m -s /bin/bash PS
sudo passwd PS
id PS
grep '^PS:' /etc/passwd
su - PS
whoami
exit
 
 
----------------------------------------------------------------
1.4  CHANGE ROOT PASSWORD
----------------------------------------------------------------
sudo passwd root
su - root
whoami
grep '^root:' /etc/shadow
exit
 
 
----------------------------------------------------------------
1.5  INSTALL MYSQL AND HAPROXY
----------------------------------------------------------------
sudo apt update
sudo apt install -y mysql-server
sudo apt install -y haproxy
sudo systemctl start mysql
sudo systemctl enable mysql
sudo systemctl start haproxy
sudo systemctl enable haproxy
sudo systemctl status mysql
sudo systemctl status haproxy
mysql --version
sudo mysql -u root -e "SELECT VERSION(); SHOW DATABASES;"
ss -tlnp | grep -E '3306|haproxy'
sudo mysql_secure_installation
 
 
----------------------------------------------------------------
1.6  FIREWALL — ALLOW PORT 3306
----------------------------------------------------------------
 
-- UFW (Ubuntu) --
sudo ufw status
sudo ufw enable
sudo ufw allow 22/tcp
sudo ufw allow 3306/tcp
sudo ufw allow 3306/udp
sudo ufw reload
sudo ufw status verbose
ss -tlnp | grep 3306
 
-- iptables (alternative) --
sudo iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 3306 -j ACCEPT
sudo apt install -y iptables-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload
sudo iptables -L INPUT -n -v
 
-- firewalld (CentOS/RHEL) --
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-port=3306/tcp
sudo firewall-cmd --permanent --add-port=3306/udp
sudo firewall-cmd --reload
sudo firewall-cmd --list-ports
sudo firewall-cmd --state
 
 
----------------------------------------------------------------
1.7  FILE TRANSFER
----------------------------------------------------------------
 
-- SCP --
scp /local/file.txt user@192.168.1.100:/remote/path/
scp -r /local/folder/ user@192.168.1.100:/home/user/folder/
scp user@192.168.1.100:/remote/file.txt /local/path/
scp -P 2222 file.txt vagrant@127.0.0.1:/home/vagrant/
 
-- SFTP --
sftp user@192.168.1.100
put file.txt
get remote_file.txt
ls
exit
 
-- rsync --
rsync -avz file.txt user@192.168.1.100:/home/user/
rsync -avz --progress /local/ user@192.168.1.100:/remote/
rsync -avz --delete /local/ user@192.168.1.100:/remote/backup/
rsync -avz --dry-run /local/ user@192.168.1.100:/remote/
 
-- Vagrant shared folder --
ls /vagrant/
cp /vagrant/myfile.txt /home/vagrant/
 
