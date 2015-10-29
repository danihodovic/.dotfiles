#!/usr/bin/env bash

read -p "Install python+pip?"                   INSTALL_PYTHON
read -p "Install zsh+oh-my-zsh+tmux?"           INSTALL_ZSH
read -p "Install Neovim ppa + neovim pip?"      INSTALL_NEOVIM
read -p "Install Dropbox?"                      INSTALL_DROPBOX

case $INSTALL_PYTHON in
    y|Y)
        sudo apt-get install python -y
        sudo wget -O - https://bootstrap.pypa.io/get-pip.py | sudo python
        ;;
esac

case $INSTALL_ZSH in
    y|Y)
        sudo apt-get install zsh -y
        git clone git@github.com:robbyrussell/oh-my-zsh ~/.oh-my-zsh
        sudo apt-get install tmux
        ;;
esac

case $INSTALL_NEOVIM in
    y|Y)
        sudo apt-add-repository ppa:neovim-ppa/unstable -y
        sudo apt-get update
        sudo apt-get install neovim -y
        hash pip 2>/dev/null
        if [ $? -eq 1 ]; then
            sudo wget -O - https://bootstrap.pypa.io/get-pip.py | sudo python
        fi
        sudo pip install neovim
        # create the neovim dir
        mkdir ~/.config/nvim
        # neovim stores backup files here but that directory isn't created by default
        mkdir ~/.local/share/nvim/backup
        ln -s ~/.dotfiles/vimrc ~/.config/nvim/init.vim
        curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        ;;
esac

case $INSTALL_DROPBOX in
    y|Y)
        sudo apt-get install python-gtk2
        wget -O tempfile https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.02.12_amd64.deb
        sudo dpkg -i tempfile
        dropbox start -i
        rm tempfile ;;
esac
