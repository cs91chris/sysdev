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

MCFLY_EP="https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh"

REPO_BAT="https://github.com/sharkdp/bat/releases/download/v${BAT_VER}/${BAT_DEB}"
REPO_LSD="https://github.com/Peltoche/lsd/releases/download/${LSD_VER}/${LSD_DEB}"
REPO_DELTA="https://github.com/dandavison/delta/releases/download/${DELTA_VER}/${DELTA_DEB}"
REPO_IREDIS="https://github.com/laixintao/iredis/releases/download/v${IREDIS_VER}/iredis.tar.gz"
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

ERR_EXIT=0
TEMP_DIR=".sysdev.temp"
SYSDEV_DIR=$(dirname "${0}")
FILE_LOG="${SYSDEV_DIR}/error.log"
# shellcheck source=/dev/null
source "${SYSDEV_DIR}/sysdev/develop/bash/color.conf"

TOOLS="$(cat "${SYSDEV_DIR}/packages")"


function install_dist_packages {    
    sudo apt update 2>> "${FILE_LOG}" && {
        # shellcheck disable=SC2086
        sudo apt install -y ${TOOLS} 2>> "${FILE_LOG}" || ERR_EXIT=1
    } || ERR_EXIT=1
}


function install_nerd_fonts {
    echo "Downloading NerdFonts..."
    for font in "${FONTS[@]}"; do
        archive=${font}.zip
        destination=${HOME}/.local/share/fonts/${font}
        mkdir -p "${destination}"
        curl -Lso "${archive}" "${NERD_FONTS_URL}/${archive}"
        unzip -qo "${archive}" -d "${destination}"
        rm -f "${archive}"
    done
}


function install_tmux {
    curl -Lso tmux-${TMUX_VER}.tar.gz ${TMUX_URL} && {
        sudo apt install libevent-dev libncurses-dev
        tar -xzf tmux-${TMUX_VER}.tar.gz
        (
            cd tmux-${TMUX_VER}
            ./configure && make
            sudo make install
        )
        rm -rf tmux-*
    } 2>> "${FILE_LOG}" || ERR_EXIT=1
}


function download_install_deb {
    local URL=${1}
    local DEB=${2}

    wget "${URL}" && {
        sudo dpkg -i "${DEB}" ; rm "${DEB}"
    } 2>> "${FILE_LOG}" || ERR_EXIT=1
}


function install_iredis {
    wget ${REPO_IREDIS} && {
        tar -xzf iredis.tar.gz
        IREDIS_DEST=${HOME}/.bin/iredis-cli
        rm -rf "${IREDIS_DEST}" iredis.tar.gz
        mkdir -p "${IREDIS_DEST}"
        mv -f iredis lib/ "${IREDIS_DEST}" 
        ln -sf "${IREDIS_DEST}/iredis" "${HOME}/.bin/iredis"
    } 2>> "${FILE_LOG}" || ERR_EXIT=1
}


function install_mcfly {
    curl -Ls ${MCFLY_EP} | \
        sudo sh -s -- --git cantino/mcfly --force --tag v${MCFLY_VER} \
        2>> "${FILE_LOG}" || ERR_EXIT=1
}


case ${1} in
    h|-h|help|--help)
    	echo -e "This script installs the following packages:"
        echo -e "\n${green}${TOOLS}${reset}\n"
    	echo -e "In case of error see ${orange}${FILE_LOG}${reset}\n"
    	exit 0
    ;;
esac

rm -rf ${TEMP_DIR}
mkdir -p ${TEMP_DIR}
cd ${TEMP_DIR} || exit 1

install_dist_packages
install_nerd_fonts
install_tmux
install_iredis
install_mcfly

download_install_deb ${REPO_BAT} ${BAT_DEB}
download_install_deb ${REPO_LSD} ${LSD_DEB}
download_install_deb ${REPO_DELTA} ${DELTA_DEB}

if [[ ${ERR_EXIT} -ne 0 ]]; then
	echo -e "${red}An error occurred! See ${FILE_LOG}${reset}"
else
    rm -rf "${TEMP_DIR}"
fi

cd - || exit 1
exit ${ERR_EXIT}
