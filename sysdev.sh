#!/bin/bash

set +o noclobber

SYSDEV_DIR=$(dirname "$0")
# shellcheck source=/dev/null
source "${SYSDEV_DIR}/sysdev/develop/bash/color.conf"

ERR_EXIT=0
FILE_LOG=${HOME}/.log/sysdev.log
VIM_BUNDLE=${HOME}/.vim/bundle
RANGER_CONF_DIR=${HOME}/.config/ranger

VER_GIT_PROMPT="2.7.1"
VER_VUNDLE="v0.10.2"
VER_LAZY_GIT="0.36.0"
VER_TMUX_CONF="fd1bbb56148101f4b286ddafd98f2ac2dcd69cd8"  # commit

REPO_VUNDLE="https://github.com/VundleVim/Vundle.vim.git"
REPO_TMUX_CONF="https://github.com/gpakosz/.tmux"
REPO_GIT_PROMPT="https://github.com/magicmonty/bash-git-prompt.git"
REPO_LAZY_GIT="https://github.com/jesseduffield/lazygit/releases/download"
REPO_RANGER_DEVICON="https://github.com/alexanderjeurissen/ranger_devicons"


function install_base {
	mkdir -p "${HOME}"/{.log,.bin}
	cd "${SYSDEV_DIR}/sysdev" > /dev/null || return

	echo -e "${orange}Installing${reset} configurations and scripts..."
	for x in *; do
		[ -d "${HOME}/.${x}" ] && tmp="${x}/*" || tmp="${x}" 
		# shellcheck disable=SC2086
		cp --verbose --recursive ${tmp} "${HOME}/.${x}" &>> "${FILE_LOG}" || ERR_EXIT=1
	done
	cd - > /dev/null || return

	if [[ -x $(which ranger 2> /dev/null) ]]; then
		ranger --copy-config=scope &>> "${FILE_LOG}" || ERR_EXIT=1
	fi
}


function install_cheat {
	echo -e "${orange}Installing cheat${reset}..."
	curl -s "https://cheat.sh/:bash_completion" > "${HOME}/.bash_conf/cht_completion" 2>> "${FILE_LOG}" || ERR_EXIT=1
	curl -s "https://cht.sh/:cht.sh" > "${HOME}/.script/cht" 2>> "${FILE_LOG}" || ERR_EXIT=1
}


function install_tmux_conf {
	if [[ -x $(which tmux 2> /dev/null ) ]]; then
		echo -e "${orange}Installing tmux${reset} configuration..."

		rm -vrf "${HOME}/.tmux" &>> "${FILE_LOG}" || ERR_EXIT=1
		git clone ${REPO_TMUX_CONF} "${HOME}/.tmux" --depth 1 &>> "${FILE_LOG}" 2>&1 && {
			(
				cd "${HOME}/.tmux" > /dev/null
				git checkout ${VER_TMUX_CONF} &>> "${FILE_LOG}" 2>&1
				cp .tmux.conf "${HOME}"
				cp .tmux.conf.local "${HOME}"
			)
		} || ERR_EXIT=1
	fi
}


function install_git_prompt {
	echo -e "${orange}Installing bash-git-prompt${reset}..."
	rm -vrf "${HOME}/.bash-git-prompt" &>> "${FILE_LOG}"
	git clone ${REPO_GIT_PROMPT} --branch ${VER_GIT_PROMPT} "${HOME}/.bash-git-prompt" --depth 1 &>> "${FILE_LOG}" || ERR_EXIT=1
}


function install_lazy_git {
	echo -e "${orange}Installing lazy git${reset}..."
	case "$(cat /proc/version)" in
		MINGW*)
			REPO_LAZY_GIT="${REPO_LAZY_GIT}/v${VER_LAZY_GIT}/lazygit_${VER_LAZY_GIT}_Windows_x86_64.zip"
			DECOMPRESSOR="unzip -o"
			EXT="zip"
		;;
		Linux*)
			REPO_LAZY_GIT="${REPO_LAZY_GIT}/v${VER_LAZY_GIT}/lazygit_${VER_LAZY_GIT}_Linux_x86_64.tar.gz"
			DECOMPRESSOR="tar -xzf"
			EXT="tar.gz"
		;;
		*)
			REPO_LAZY_GIT=""
			echo -e "not supported OS: $(cat /proc/version)"
		;;
	esac

	if [[ -n "${REPO_LAZY_GIT}" ]]; then
		rm -rf "${HOME}"/.bin/lazygit* 2>> "${FILE_LOG}"
		wget -O "${HOME}/.bin/lazygit.${EXT}" "${REPO_LAZY_GIT}" 2>> "${FILE_LOG}" > /dev/null && {
			(
				cd "${HOME}"/.bin > /dev/null
				${DECOMPRESSOR} "lazygit.${EXT}" &>> "${FILE_LOG}"
				rm -vrf LICENSE README.md &>> "${FILE_LOG}"
			)
		} || ERR_EXIT=1
	fi
}


function install_vim_plugins {
	if [[ -x $(which vim 2> /dev/null) ]]; then
		echo -e "${orange}Setting vim${reset} configurations..."

		rm -vrf "${VIM_BUNDLE}/Vundle.vim" &>> "${FILE_LOG}" || ERR_EXIT=1
		git clone ${REPO_VUNDLE} "${VIM_BUNDLE}/Vundle.vim" --branch ${VER_VUNDLE} --depth 1 &>> "${FILE_LOG}" && {
			vim +PluginInstall +qall
		} || ERR_EXIT=1
	fi
}


function install_ranger_devicon {
	echo -e "${orange}Setting ranger${reset} devicons..."
	rm -vrf "${RANGER_CONF_DIR}/plugins/ranger_devicons" &>> "${FILE_LOG}" || ERR_EXIT=1
	git clone --depth 1 "${REPO_RANGER_DEVICON}" "${RANGER_CONF_DIR}/plugins/ranger_devicons" &>> "${FILE_LOG}" && {
		echo -e "\n# DevIcons Config" >> "${RANGER_CONF_DIR}/rc.conf"
		echo "default_linemode devicons" >> "${RANGER_CONF_DIR}/rc.conf"
	} || ERR_EXIT=1
}


if [[ $1 == "--help" ]]; then
	cat "${SYSDEV_DIR}/README.md"
	echo -e "In case of error see ${orange}${FILE_LOG}${reset}\n"
	exit 0
fi

echo -e "${red}Warning${reset}: this will replace configuration files in your home!"
read -p "Do you want continue? [yes/N]: " -r ANS

case "${ANS}" in
	yes) ;;
	*) exit 1 ;;
esac

install_base
install_cheat
install_tmux_conf
install_git_prompt
install_lazy_git
install_vim_plugins
install_ranger_devicon

chmod +x "${HOME}"/{.script,.bin}/* >> "${FILE_LOG}" 2>&1

if [[ ${ERR_EXIT} -eq 1 ]]; then
	echo -e "${red}"
	msg_text="something went wrong see ${FILE_LOG}"
else
	echo -e "${green}"
	msg_text="ALL DONE"
fi

echo -e "${msg_text}!${reset} "
cd - > /dev/null || exit 1
exit ${ERR_EXIT}
