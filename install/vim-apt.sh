#!/usr/bin/env bash
read -p "Remove existing vim?"              REMOVE_VIM
read -p "Install daily vim ppa?"            INSTALL_VIM
read -p "Install NeoVim?"                   INSTALL_NEOVIM
read -p "Install Plug + Plugins?"         INSTALL_VIM_PLUG
read -p "Install YCM dependencies?"         INSTALL_YCM_DEPS
read -p "Install extra (ag)?"               INSTALL_EXTRA

case $REMOVE_VIM in
    [yY])
        echo "Removing vim libs"
        sudo apt-get remove vim vim-runtime gvim vim-tiny vim-common vim-gui-common -y
        ;;
esac

case $INSTALL_VIM in
    [yY])
        echo "Installing vim from ppa"
        sudo apt-add-repository ppa:pkg-vim/vim-daily -y
        sudo apt-get update
        sudo apt-get install vim vim-gtk -y
        ;;
esac

case $INSTALL_NEOVIM in
    [yY])
        echo "Installing Neovim"
        sudo add-apt-repository ppa:neovim-ppa/unstable -y
        sudo apt-get update
        sudo apt-get install neovim xclip -y
        wget -O - https://bootstrap.pypa.io/get-pip.py | sudo python
        sudo pip install neovim
        ;;
esac

case $INSTALL_VIM_PLUG in
    [yY])
        echo "Installing Vim Plug + Plugins..."
        wget -O ~/.vim/autoload/plug.vim --force-directories https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        vim +PlugInstall +qa
        ;;
esac

case $INSTALL_YCM_DEPS in
    [yY])
        echo "Installing YCM dependencies..."
        YCM_DIR=~/.vim/bundle/YouCompleteMe
        if [[ ! -d "$YCM_DIR" ]]; then
            cd "$YCM_DIR"
            sudo apt-get install cmake g++ -y
            sh install.sh
        else 
            echo "YCM dir already exists, skipping install"
        fi
        ;;
esac

case $INSTALL_EXTRA in
    [yY])
        echo "Installing Ag"
        sudo apt-get install silversearcher-ag
        ;;
esac
