#!/bin/bash

set +o noclobber

SYSDEV_DIR=$(dirname "$0")
source ${SYSDEV_DIR}/sysdev/develop/bash/color.conf

ERR_EXIT=0
FILE_LOG=${HOME}/.log/sysdev.log
VIM_BUNDLE=${HOME}/.vim/bundle

VER_GIT_PROMPT="2.7.1"
VER_VUNDLE="v0.10.2"
VER_TMUX_CONF="d6f0f647dd68561ed010f83d8d226383aebfb805"
VER_LAZY_GIT="0.20.4"

REPO_VUNDLE="https://github.com/VundleVim/Vundle.vim.git"
REPO_TMUX_CONF="https://github.com/gpakosz/.tmux.git"
REPO_GIT_PROMPT="https://github.com/magicmonty/bash-git-prompt.git"
REPO_LAZY_GIT="https://github.com/jesseduffield/lazygit/releases/download"
REPO_LAZY_GIT_NIX="${REPO_LAZY_GIT}/v${VER_LAZY_GIT}/lazygit_${VER_LAZY_GIT}_Linux_x86_64.tar.gz"
REPO_LAZY_GIT_WIN="${REPO_LAZY_GIT}/v${VER_LAZY_GIT}/lazygit_${VER_LAZY_GIT}_Windows_x86_64.zip"


if [[ $1 == "--help" ]]; then
	cat ${SYSDEV_DIR}/README.md
	echo -e "In case of error see ${orange}${FILE_LOG}${reset}\n"
	exit 0
fi

echo -e "${red}Warning${reset}: this will replace configuration files in your home!"
read -p "Do you want continue? [yes/N]: " -r ANS

case "${ANS}" in
	yes) ;;
	*) exit 1 ;;
esac


echo -e "${orange}Installing${reset} configurations and scripts..."

mkdir -p ${HOME}/{.log,.bin}
cd ${SYSDEV_DIR}/sysdev > /dev/null

for x in $(ls); do
	[ -d ${HOME}/.${x} ] && tmp="${x}/*" || tmp="${x}" 
	cp --verbose --recursive ${tmp} ${HOME}/.${x} &>> ${FILE_LOG} || ERR_EXIT=1
done
cd - > /dev/null

if [[ -x $(which ranger 2> /dev/null) ]]; then
    ranger --copy-config=scope &>> ${FILE_LOG} || ERR_EXIT=1
fi

curl -s "https://cheat.sh/:bash_completion" > ${HOME}/.bash_conf/cht_completion 2>> ${FILE_LOG} || ERR_EXIT=1
curl -s "https://cht.sh/:cht.sh" > ${HOME}/.script/cht 2>> ${FILE_LOG} || ERR_EXIT=1

chmod +x ${HOME}/{.script,.bin}/* >> ${FILE_LOG} 2>&1

if [[ -x $(which tmux 2> /dev/null ) ]]; then
    echo -e "${orange}Installing tmux${reset} configuration..."

	rm -vrf ${HOME}/.tmux &>> ${FILE_LOG} || ERR_EXIT=1
    git clone ${REPO_TMUX_CONF} ${HOME}/.tmux --depth 1 >> ${FILE_LOG} 2>&1 && {
		cd ${HOME}/.tmux > /dev/null
		git checkout -b tmp ${VER_TMUX_CONF}
        cp .tmux.conf ${HOME}
        cp .tmux.conf.local ${HOME}
		cd - > /dev/null
    } || ERR_EXIT=1
fi

rm -vrf ${HOME}/.bash-git-prompt &>> ${FILE_LOG}
git clone ${REPO_GIT_PROMPT} --branch ${VER_GIT_PROMPT} ${HOME}/.bash-git-prompt --depth 1 &>> ${FILE_LOG}

case "$(cat /proc/version)" in
	MINGW*)
		REPO_LAZY_GIT=${REPO_LAZY_GIT_WIN}
		DECOMPRESSOR="unzip -o"
		EXT="zip"
	;;
	Linux*)
		REPO_LAZY_GIT=${REPO_LAZY_GIT_NIX}
		DECOMPRESSOR="tar -xzf"
		EXT="tar.gz"
	;;
	*)
		REPO_LAZY_GIT=""
		echo -e "not supported OS: $(cat /proc/version)"
	;;
esac

if [[ ! -z "${REPO_LAZY_GIT}" ]]; then
	rm -vrf ${HOME}/.bin/lazygit* &>> ${FILE_LOG}
	wget -O ${HOME}/.bin/lazygit.${EXT} "${REPO_LAZY_GIT}" 2>> ${FILE_LOG} > /dev/null && {
		cd ${HOME}/.bin > /dev/null
		${DECOMPRESSOR} lazygit.${EXT} &>> ${FILE_LOG}
		rm -vrf LICENSE README.md &>> ${FILE_LOG}
		cd - > /dev/null
	} || ERR_EXIT=1
fi

if [[ -x $(which vim 2> /dev/null) ]]; then
    echo -e "${orange}Setting vim${reset} configurations..."

    rm -vrf ${VIM_BUNDLE}/Vundle.vim &>> ${FILE_LOG} || ERR_EXIT=1
    git clone ${REPO_VUNDLE} ${VIM_BUNDLE}/Vundle.vim --branch ${VER_VUNDLE} --depth 1 &>> ${FILE_LOG} && {
		vim +PluginInstall +qall

		echo -e "${orange}compiling${reset} youCompleteMe..."

		cd ${VIM_BUNDLE}/YouCompleteMe > /dev/null
		[[ -x $(which python3 2> /dev/null) ]] && PYTHON_CMD=python3 || PYTHON_CMD=python
		${PYTHON_CMD} install.py --clang-completer 2>> ${FILE_LOG} > /dev/null || ERR_EXIT=1
	} || ERR_EXIT=1
fi


if [[ ${ERR_EXIT} -eq 1 ]]; then
	echo -e "${red}"
	msg_text="something went wrong see ${FILE_LOG}"
else
	echo -e "${green}"
	msg_text="ALL DONE"
fi

echo -e "${msg_text}!${reset} "
cd - > /dev/null
exit ${ERR_EXIT}

