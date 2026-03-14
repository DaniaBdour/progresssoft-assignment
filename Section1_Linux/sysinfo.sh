#!/bin/bash
EXEC_USER=$(whoami)
HOSTNAME_VAL=$(hostname)
SERVER_IP=$(hostname -I | awk '{print $1}')
PUBLIC_IP=$(curl -s https://api.ipify.org 2>/dev/null || echo 'N/A')
OS=$(lsb_release -d | cut -f2)
KERNEL=$(uname -r)
ARCH=$(uname -m)
VIRT=$(systemd-detect-virt 2>/dev/null || echo 'unknown')
SERVER_TIME=$(date '+%Y-%m-%d %H:%M:%S %Z')
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
