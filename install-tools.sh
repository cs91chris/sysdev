#!/bin/bash

set +o noclobber

SYSDEV_DIR=$(dirname "$0")
source ${SYSDEV_DIR}/sysdev/develop/bash/color.conf

FILE_LOG=${SYSDEV_DIR}/error.log

ERR_EXIT=0

TOOLS="$(cat ${SYSDEV_DIR}/packages)"

case $1 in
    h|-h|help|--help)
    	echo -e "${red}Root privileges required${reset}. This script installs the following packages:"
        echo -e "\n${green}${TOOLS}${reset}\n"
    	echo -e "In case of error see ${orange}${FILE_LOG}${reset}\n"
    	exit 0
    ;;
esac

if [[ "${EUID}" -ne 0 ]]; then
    echo -e "\n${red}ERROR: Please run as root${reset}\n"
    exit 1
fi

apt update 2>> ${FILE_LOG} && {
	for pkg in ${TOOLS}; do
		apt install ${pkg} -y 2>> ${FILE_LOG} || ERR_EXIT=1
	done
} || ERR_EXIT=1


if [[ ${ERR_EXIT} -ne 0 ]]; then
	echo -e "${red}An error occurred! See ${FILE_LOG}${reset}"
fi

exit ${ERR_EXIT}

