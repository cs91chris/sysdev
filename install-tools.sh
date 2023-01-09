#!/bin/bash

set +o noclobber

BAT_VER=0.22.1
LSD_VER=0.23.1
DELTA_VER=0.15.1
MCFLY_VER=0.7.0
IREDIS_VER=1.12.1
NERD_FONTS_VER=2.2.2
TMUX_VER=3.3

BAT_DEB=bat_${BAT_VER}_amd64.deb
LSD_DEB=lsd_${LSD_VER}_amd64.deb
DELTA_DEB=git-delta-musl_${DELTA_VER}_amd64.deb
IREDIS_PKG=iredis.tar.gz

MCFLY_EP="https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh"

REPO_BAT="https://github.com/sharkdp/bat/releases/download/v${BAT_VER}/${BAT_DEB}"
REPO_LSD="https://github.com/Peltoche/lsd/releases/download/${LSD_VER}/${LSD_DEB}"
REPO_DELTA="https://github.com/dandavison/delta/releases/download/${DELTA_VER}/${DELTA_DEB}"
REPO_IREDIS="https://github.com/laixintao/iredis/releases/download/v${IREDIS_VER}/${IREDIS_PKG}"
NERD_FONTS_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERD_FONTS_VER}"
TMUX_URL="https://github.com/tmux/tmux/releases/download/${TMUX_VER}/tmux-${TMUX_VER}.tar.gz"

FONTS=(                  
    FiraCode
    FiraMono
    Go-Mono
    Hack
    Hermit
    JetBrainsMono
    RobotoMono
    NerdFontsSymbolsOnly
    Ubuntu
    UbuntuMono
)

TEMP_DIR=.sysdev.temp
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

rm -rf ${TEMP_DIR}
mkdir -p ${TEMP_DIR}
cd ${TEMP_DIR}


sudo apt update 2>> ${FILE_LOG} && {
	for pkg in ${TOOLS}; do
		sudo apt install ${pkg} -y 2>> ${FILE_LOG} || ERR_EXIT=1
	done
} || ERR_EXIT=1

echo "downloading NerdFonts..."
for font in ${FONTS[@]}; do
    archive=${font}.zip
    destination=${HOME}/.local/share/fonts/${font}
    mkdir -p ${destination}
    curl -Lso ${archive} "${NERD_FONTS_URL}/${archive}"
    unzip -qo ${archive} -d ${destination}
    rm -f ${archive}
done

curl -Ls --output tmux-${TMUX_VER}.tar.gz ${TMUX_URL} && {
    sudo apt install libevent-dev libncurses-dev
    tar -xzf tmux-${TMUX_VER}.tar.gz
    (
        cd tmux-${TMUX_VER}
        ./configure && make
        sudo make install
    )
    rm -rf tmux-*
}

wget ${REPO_BAT} && {
    sudo dpkg -i ${BAT_DEB}
    rm ${BAT_DEB}
} 2>> ${FILE_LOG} || ERR_EXIT=1

wget ${REPO_LSD} && {
    sudo dpkg -i ${LSD_DEB}
    rm ${LSD_DEB}
} 2>> ${FILE_LOG} || ERR_EXIT=1

wget ${REPO_DELTA} && {
    sudo dpkg -i ${DELTA_DEB}
    rm ${DELTA_DEB}
} 2>> ${FILE_LOG} || ERR_EXIT=1

wget ${REPO_IREDIS} && {
    tar -xzf ${IREDIS_PKG}
    IREDIS_DEST=${HOME}/.bin/iredis-cli
    rm -rf ${IREDIS_DEST} ${IREDIS_PKG}
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
