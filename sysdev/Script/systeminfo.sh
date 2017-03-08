#!/bin/bash

clear
source ~/Script/color.conf 2> /dev/null


echo -e " - ${orange}KERNEL${reset}: ${green}`uname -s` `uname -m`${reset}"
echo -e " - ${orange}KERNEL-RELEASE${reset}: ${green}`uname -r`${reset}"
echo -e " - ${orange}KERNEL-VERSION${reset}: ${green}`uname -v`${reset}"

[ `uname -p` != "unknown" ] && {
	echo -e " - ${orange}PROCESSOR${reset}: ${green}`uname -p`${reset}"
}

[ `uname -i` != "unknown" ] && {
	echo -e " - ${orange}PLATFORM${reset}: ${green}`uname -i`${reset}"
}


echo -e "\n - ${orange}USER${reset}: ${green}$USER${reset}"
echo -e " - ${orange}HOSTNAME${reset}: ${green}`uname -n`${reset}"
echo -e " - ${orange}DATE${reset}: ${green}`date "+%a %e %b %Y %H:%M"`${reset}"


echo -e "\n - ${orange}UPTIME${reset}: " ; uptime
echo -e "\n - ${orange}CONNECTED-USERS${reset}:" ; w -s -i -h
echo -e "\n - ${orange}DISK-INFO${reset}:" ; pydf -H
echo -e "\n- ${orange}MEM-INFO${reset}:" ; free -m


echo -e "\n- ${orange}CPU-INFO${reset}:"
lshw -C cpu | awk '/product/ || /version/ || /size/ || /capacity/ || /width/' | head -n6


