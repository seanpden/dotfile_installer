#!/bin/bash

# color codes
RESTORE='\033[0m'
NC='\033[0m'
BLACK='\033[00;30m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
SEA="\\033[38;5;49m"
LIGHTGRAY='\033[00;37m'
LBLACK='\033[01;30m'
LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'
OVERWRITE='\e[1A\e[K'

#emoji codes
CHECK_MARK="${GREEN}\xE2\x9C\x94${NC}"
X_MARK="${RED}\xE2\x9C\x96${NC}"
PIN="${RED}\xF0\x9F\x93\x8C${NC}"
CLOCK="${GREEN}\xE2\x8C\x9B${NC}"
ARROW="${SEA}\xE2\x96\xB6${NC}"
BOOK="${RED}\xF0\x9F\x93\x8B${NC}"
HOT="${ORANGE}\xF0\x9F\x94\xA5${NC}"
WARNING="${RED}\xF0\x9F\x9A\xA8${NC}"
RIGHT_ANGLE="${GREEN}\xE2\x88\x9F${NC}"


DOTFILES_LOG="$HOME/.dotfiles.log"

# _header colorize the given argument with spacing
function _task {
    # if _task is called while a task was set, complete the previous
    if [[ $TASK != "" ]]; then
        printf "${OVERWRITE}${LGREEN} [✓]  ${LGREEN}${TASK}\n"
    fi
    # set new task title and print
    TASK=$1
    printf "${LBLACK} [ ]  ${TASK} \n${LRED}"
}

# _cmd performs commands with error checking
function _cmd {
    #create log if it doesn't exist
    if ! [[ -f $DOTFILES_LOG ]]; then
        touch $DOTFILES_LOG
    fi
    # empty conduro.log
    > $DOTFILES_LOG
    # hide stdout, on error we print and exit
    if eval "$1" 1> /dev/null 2> $DOTFILES_LOG; then
        return 0 # success
    fi
    # read error from log and add spacing
    printf "${OVERWRITE}${LRED} [X]  ${TASK}${LRED}\n"
    while read line; do
        printf "      ${line}\n"
    done < $DOTFILES_LOG
    printf "\n"
    # remove log file
    rm $DOTFILES_LOG
    # exit installation
    exit 1
}

function _clear_task {
    TASK=""
}

function _task_done {
    printf "${OVERWRITE}${LGREEN} [✓]  ${LGREEN}${TASK}\n"
    _clear_task
}


set -e


function init {
  _task "apt-get Update and Upgrade"
  _cmd "sudo apt-get update && sudo apt-get upgrade -y"
}


function install_git {
  _task "Checking for Git"
  if ! dpkg -s git >/dev/null 2>&1; then
      _task "Installing Git"
          _cmd "sudo apt-get install -y git-all"
  fi

}


function install_rust {
  _task "Installing/Updating Rust"
  _cmd "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
}


function install_python {
  _task "Checking for Python3"
  # Check if python3 and pip is installed
  if ! dpkg -s python3 >/dev/null 2>&1; then
      _task "Installing Python3"
          _cmd "sudo apt-get install -y python3"
  fi

  _task "Checking for Pip"
  if ! dpkg -s python3-pip >/dev/null 2>&1; then
      _task "Installing Python3 Pip"
          _cmd "sudo apt-get install -y python3-pip"
  fi
}


function install_go {
  _task "Checking for Go"
  if [ ! -d /usr/local/go ]; then
      _task "Installing Go"
          _cmd "wget 'https://go.dev/dl/go1.22.0.linux-amd64.tar.gz'"
          _cmd "sudo rm -rf /usr/local/go"
          _cmd "sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz"
          _cmd "sudo rm -rf go1.22.0.linux-amd64.tar.gz"
          # echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
  fi
}


function install_crates {
  _task "Installing Starship"
  _cmd "cargo install starship --locked"
  _task "Installing  Bat"
  _cmd "cargo install --locked bat"
  _task "Installing Eza"
  _cmd "cargo install eza"
  _task "Installing  Fd-find"
  _cmd "cargo install fd-find"
  _task "Installing GitUI"
  _cmd "cargo install gitui"
  _task "Installing RipGrep"
  _cmd "cargo install ripgrep"
  _task "Installing SCCache"
  _cmd "cargo install sccache --locked"
  _task "Installing Zellij"
  _cmd "cargo install --locked zellij"
  _task "Installing Nu"
  _cmd "cargo install nu"
}


function install_neofetch {
  _task "Checking for Neofetch"
  if ! dpkg -s neofetch >/dev/null 2>&1; then
      _task "Installing Neofetch"
          _cmd "sudo apt-get install -y neofetch"
  fi

}


function install_nvim {
  _task "Checking for NeoVim"
  if [ ! -f ~/nvim.appimage ]; then
    _task "Installing NeoVim"
        _cmd "curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
        _cmd "sudo rm -rf /opt/nvim"
        _cmd "sudo tar -C /opt -xzf nvim-linux64.tar.gz"
        echo "export PATH=$PATH:/opt/nvim-linux64/bin" >> ~/.bashrc
  fi
}


function install_nvm {
  _task "Checking for NVM"
  if [ ! -d ~/.nvm/.git ]; then
    _task "Installing NVM"
        _cmd "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
  fi
}


function install_node {
  _task "Checking for Node"
  if ! which node >/dev/null; then
    _task "Installing Node/NPM"
        _cmd "nvm install node"
  fi
}


function install_make {
  _task "Checking for Make"
  if ! dpkg -s make >/dev/null 2>&1; then
      _task "Installing Make"
          _cmd "sudo apt-get install -y make"
  fi
}


function install_cmake {
  _task "Checking for CMake"
  if ! dpkg -s cmake >/dev/null 2>&1; then
      _task "Installing CMake"
          _cmd "sudo apt-get install -y cmake"
  fi
}


function install_lvim {
  _task "Checking for LVIM"
  if ! which lvim >/dev/null; then
    _task "Installing LVIM"
        _cmd "LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)"
  fi

}


function install_dotfiles {
  _task "Checking for dotfiles folder"
  if [ ! -d ~/dotfiles ]; then
    _task "Installing dotfiles"
        _cmd "git clone https://github.com/seanpden/dotfiles.git ~/dotfiles/"
        _cmd "stow ~/dotfiles/."
  fi
}


function install_gnu_stow {
  _task "Checking for GNU Stow"
  if ! dpkg -s stow >/dev/null 2>&1; then
      _task "Installing GNU Stow"
          _cmd "sudo apt-get install -y stow"
  fi
}


main () {
  init
  install_make
  install_cmake
  install_git
  install_rust
  install_python
  install_go
  install_crates
  install_neofetch
  install_nvim
  install_nvm
  install_node
  install_lvim
  install_gnu_stow
  install_dotfiles
  _task_done
}


main
