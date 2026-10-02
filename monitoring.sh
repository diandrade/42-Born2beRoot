#!/bin/bash

echo "#Architecture: $(uname -a)"

echo "#Physical CPU: $(lscpu | awk '/^Socket\(s\):/ {print $2}')"

echo "#vCPU: $(nproc)"

echo "#Memory Usage: $(free -m | awk 'NR==2 {printf "%d/%dMB (%.2f%%)", $3, $2, $3/$2*100}')"

echo "#Disk Usage: $(df -BG / | awk 'NR==2 {gsub("G","",$3); gsub("G","",$2); printf "%d/%dGb (%d%%)", $3, $2, $5}')"

echo "#CPU load: $(top -bn1 | awk '/Cpu\(s\)/ {printf "%.1f%%", 100 - $8}')"

echo "#Last boot: $(who -b | awk '{print $3, $4}')"

echo "#LVM use: $(lsblk | grep -q "lvm" && echo "yes" || echo "no")"

echo "#TCP Connections: $(ss -ta | grep ESTAB | wc -l) ESTABLISHED"

echo "#User log: $(who | wc -l)"

INTERFACE=$(ip route | awk '/default/ {print $5; exit}')
IP=$(ip -4 addr show "$INTERFACE" | awk '/inet / {print $2}' | cut -d/ -f1)
MAC=$(ip link show "$INTERFACE" | awk '/link\/ether/ {print $2}')

echo "#Network: IP $IP ($MAC)"

SUDO_COUNT=$(grep -h "sudo:" /var/log/auth.log* 2>/dev/null | grep -c "COMMAND=") 

echo "#Sudo: $SUDO_COUNT cmd"
