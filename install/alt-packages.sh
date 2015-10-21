#!/usr/bin/env bash

read -p "Install Neovim ppa + neovim pip?"      INSTALL_NEOVIM
read -p "Install python+pip?"                   INSTALL_PYTHON
read -p "Install Dropbox?"                      INSTALL_DROPBOX
read -p "Install bro?"                          INSTALL_BRO
read -p "Install howdoi?"                       INSTALL_HOWDOI
read -p "Install commandlinefu?"                INSTALL_CLF

case $INSTALL_NEOVIM in
    y|Y)
        sudo apt-add-repository ppa:neovim-ppa/unstable -y
        sudo apt-get update
        sudo apt-get install neovim -y
        sudo pip install neovim
esac

case $INSTALL_PYTHON in
    y|Y)
        sudo apt-get install python -y
        sudo wget -O - https://bootstrap.pypa.io/get-pip.py | python
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

case $INSTALL_BRO in
    y|Y)
        sudo apt-get install ruby ruby-dev -y
        sudo gem install bropages
        ;;
esac

case $INSTALL_HOWDOI in
    y|Y)
        sudo apt-get install libxml2-dev libxslt1-dev -y
        sudo pip install howdoi
        ;;
esac

case $INSTALL_CLF in
    y|Y)
        sudo pip install clf
        ;;
esac
