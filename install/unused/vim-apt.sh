#!/usr/bin/env bash
read -p "Remove existing vim?"              REMOVE_VIM
read -p "Install daily vim ppa?"            INSTALL_VIM
read -p "Install neovim?"                   INSTALL_NEOVIM
read -p "Install neovim-qt?"                INSTALL_NEOVIM_QT
read -p "Install Plug + Plugins?"           INSTALL_VIM_PLUG
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

case $INSTALL_NEOVIM_QT in
    y|Y )
        # Note: The build scripts in the neovim-qt repo are not usual build
        # scripts as it seems to be used for mostly development of the lib.
        # To get the gui executable we just copy the binary to `/opt`
        # This probably isn't a sustainable method as the github repo will update
        if [[ ! -d /opt/neovim-qt ]]; then
            echo "Installing neovim-qt..."
            TEMP=neovim-qt
            INSTALL_DIR=/opt/nvim-qt
            sudo apt-get install qt5-default
            git clone git@github.com:equalsraf/neovim-qt.git $TEMP
            cd $TEMP
            mkdir build && cd build
            cmake .. && make
            mkdir $INSTALL_DIR 
            cp bin/nvim-qt $INSTALL_DIR 
            cd ../.. && rm -rf $TEMP
        fi
        ;;
esac

case $INSTALL_VIM_PLUG in
    [yY])
        echo "Installing Vim Plug + Plugins..."
        PLUG_DIR=~/.vim/autoload/
        mkdir -p $PLUG_DIR
        wget -O $PLUG_DIR/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        vim +PlugInstall +qa
        ;;
esac

case $INSTALL_YCM_DEPS in
    [yY])
        echo "Installing YCM dependencies..."
        sudo apt-get install cmake g++ -y
        ;;
esac

case $INSTALL_EXTRA in
    [yY])
        echo "Installing Ag"
        sudo apt-get install silversearcher-ag
        ;;
esac
