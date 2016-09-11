#!/usr/bin/env bash

read -p "Install node version manager (n)? " -n 1 -r      install_n
echo
read -p "Install FZF? " -n 1 -r      install_fzf
echo
read -p "Install i3-completions for zsh? " -n 1 -r      install_i3_completions
echo
read -p "Install dasht? Cli tool for reading docs [y/n] " -n 1 -r INSTALL_DASHT
echo

scripts=${HOME}/.scripts

case $install_n in
    y)
      if [ ! -d "${HOME}/.n" ]; then
        git clone https://github.com/tj/n ${HOME}/.n
        cd" ${HOME}/.n"
        PREFIX=bin make install
      else
        echo "N already installed"
      fi
esac


case $install_fzf in
  y)
    if [[ ! -f "$scripts/fzf/fzf" ]]; then
      git clone --depth 1 https://github.com/junegunn/fzf.git "$scripts/fzf"
      "$scripts"/fzf/install
    else
      echo "FZF already installed"
    fi
esac


case $install_i3_completions in
  y)
    if [[ ! -f "$scripts/i3_completion.sh" ]]; then
      url=https://raw.githubusercontent.com/cornerman/i3-completion/master/i3_completion.sh
      curl $url -o "$scripts/i3_completion.sh"
    else
      echo "i3-completions already installed"
    fi
esac

case $INSTALL_DASHT in
  y|Y)
    sudo apt-get install sqlite3 w3m wget -y
    git clone https://github.com/sunaku/dasht.git "${HOME}/.dasht"
    ;;
esac
