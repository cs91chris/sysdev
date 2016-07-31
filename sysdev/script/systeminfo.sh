#!/bin/bash

clear
source color.conf


echo -e " - ${orange}KERNEL${reset}: ${green}`uname -s` `uname -m`${reset}"
echo -e " - ${orange}KERNEL-RELEASE${reset}: ${green}`uname -r`${reset}"
echo -e " - ${orange}KERNEL-VERSION${reset}: ${green}`uname -v`${reset}"

if [ `uname -p` != "unknown" ]; then
	echo -e " - ${orange}PROCESSOR${reset}: ${green}`uname -p`${reset}"
fi

if [ `uname -i` != "unknown" ]; then
	echo -e " - ${orange}PLATFORM${reset}: ${green}`uname -i`${reset}"
fi

echo -e "\n - ${orange}USER${reset}: ${green}$USER${reset}"
echo -e " - ${orange}HOSTNAME${reset}: ${green}`uname -n`${reset}"
echo -e " - ${orange}DATE${reset}: ${green}`date "+%a %e %b %Y %H:%M"`${reset}"


echo "\n - ${orange}UPTIME${reset}: `uptime`"
echo -e "\n - ${orange}CONNECTED-USERS${reset}:"; w -s -i -h
echo -e "\n - ${orange}DISK-INFO${reset}:"; pydf -H
echo -e "\n- ${orange}MEM-INFO${reset}:"; free -m

echo -e "\n- ${orange}CPU-INFO${reset}:"
sudo lshw -C cpu | awk '/version/ || /product/'

sudo lshw -C cpu | awk '{if ($0 ~ "logical"){skip = 1}; if(skip == 1){next};if($0 ~ "product|version|width"){sub("[]*","",$0); print $0}}' 

