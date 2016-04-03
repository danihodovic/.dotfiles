#!/usr/bin/env bash

read -p "Install node version manager (nvm)? " -n 1 -r      install_nvm
echo
read -p "Install FZF? " -n 1 -r      install_fzf
echo
read -p "Install i3-completions for zsh? " -n 1 -r      install_i3_completions
echo

scripts=${HOME}/.scripts

case $install_nvm in
    y)
      if [[ ! -f "$scripts/nvm/nvm.sh" ]]; then
        git clone https://github.com/creationix/nvm.git "$scripts/nvm"
        read -p "Install latest node and set as stable?" INSTALL_NODE
        case $INSTALL_NODE in
            y)
                source "$scripts/nvm/nvm.sh"
                nvm install node
                nvm alias default node
        esac
      else
          echo "Nvm already installed"
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
      curl -flO  \
        https://raw.githubusercontent.com/cornerman/i3-completion/master/i3_completion.sh > \
        "$scripts/i3_completion.sh"
    else
      echo "i3-completions already installed"
    fi
esac

