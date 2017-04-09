#!/bin/bash

clear
source ~/.script/color.conf 2> /dev/null

echo
echo -e " - ${orange}USER${reset}: ${green}$USER${reset}"
echo -e " - ${orange}HOSTNAME${reset}: ${green}`uname -n`${reset}"
echo -e " - ${orange}UPTIME${reset}: ${green}`uptime --pretty`${reset}"
echo -e " - ${orange}DATE${reset}: ${green}`date "+%A %e %B %Y %H:%M"`${reset}"
echo
echo -e " - ${orange}KERNEL${reset}: ${green}`uname -s` `uname -m`${reset}"
echo -e " - ${orange}KERNEL-RELEASE${reset}: ${green}`uname -r`${reset}"
echo

[ `uname -p` != "unknown" ] && {
	echo -e " - ${orange}PROCESSOR${reset}: ${green}`uname -p`${reset}"
}
[ `uname -i` != "unknown" ] && {
	echo -e " - ${orange}PLATFORM${reset}: ${green}`uname -i`${reset}"
}

echo
echo -e "\n - ${orange}CONNECTED-USERS${reset}:"
w -s -i -h

echo -e "\n - ${orange}DISK-INFO${reset}:"
df -Th | grep -v tmpfs

echo -e "\n - ${orange}MEM-INFO${reset}:"
free -mth

[ -x $(which lshw) ] && {
	echo -e "\n - ${orange}CPU-INFO${reset}:"
	lshw -C cpu 2> /dev/null | awk '/product/||/size/||/capacity/||/width/'
}
echo

