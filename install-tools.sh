#!/bin/bash

set +o noclobber

BAT_VER=0.18.1
LSD_VER=0.20.1
DELTA_VER=0.8.0
MCFLY_VER=0.5.7
IREDIS_VER=1.9.4
BAT_DEB=bat_${BAT_VER}_amd64.deb
LSD_DEB=lsd_${LSD_VER}_amd64.deb
DELTA_DEB=git-delta-musl_${DELTA_VER}_amd64.deb
MCFLY_EP=https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh
IREDIS_PKG=iredis.tar.gz

TEMP_FILE=.sysdev.temp
SYSDEV_DIR=$(dirname "$0")
source ${SYSDEV_DIR}/sysdev/develop/bash/color.conf

FILE_LOG=${SYSDEV_DIR}/error.log

ERR_EXIT=0

TOOLS="$(cat ${SYSDEV_DIR}/packages)"

case $1 in
    h|-h|help|--help)
    	echo -e "This script installs the following packages:"
        echo -e "\n${green}${TOOLS}${reset}\n"
    	echo -e "In case of error see ${orange}${FILE_LOG}${reset}\n"
    	exit 0
    ;;
esac

sudo apt update 2>> ${FILE_LOG} && {
	for pkg in ${TOOLS}; do
		sudo apt install ${pkg} -y 2>> ${FILE_LOG} || ERR_EXIT=1
	done
} || ERR_EXIT=1


rm -rf ${TEMP_FILE}
mkdir -p ${TEMP_FILE}
cd ${TEMP_FILE}

wget https://github.com/sharkdp/bat/releases/download/v${BAT_VER}/${BAT_DEB} && {
    sudo dpkg -i ${BAT_DEB}
    rm ${BAT_DEB}
} 2>> ${FILE_LOG} || ERR_EXIT=1

wget https://github.com/Peltoche/lsd/releases/download/${LSD_VER}/${LSD_DEB} && {
    sudo dpkg -i ${LSD_DEB}
    rm ${LSD_DEB}
} 2>> ${FILE_LOG} || ERR_EXIT=1

wget https://github.com/dandavison/delta/releases/download/${DELTA_VER}/${DELTA_DEB} && {
    sudo dpkg -i ${DELTA_DEB}
    rm ${DELTA_DEB}
} 2>> ${FILE_LOG} || ERR_EXIT=1

wget https://github.com/laixintao/iredis/releases/download/v${IREDIS_VER}/${IREDIS_PKG} && {
    tar -xzf ${IREDIS_PKG}
    IREDIS_DEST=${HOME}/.bin/iredis-cli
    rm -rf ${IREDIS_DEST}
    mkdir -p ${IREDIS_DEST}
    mv -f iredis lib/ ${IREDIS_DEST} 
    ln -sf ${IREDIS_DEST}/iredis ${HOME}/.bin/iredis
} 2>> ${FILE_LOG} || ERR_EXIT=1

curl ${MCFLY_EP} | sudo sh -s -- --git cantino/mcfly --force --tag v${MCFLY_VER} 2>> ${FILE_LOG} || ERR_EXIT=1

if [[ ${ERR_EXIT} -ne 0 ]]; then
	echo -e "${red}An error occurred! See ${FILE_LOG}${reset}"
else
    rm -rf ${TEMP_FILE}
fi

cd -
exit ${ERR_EXIT}

