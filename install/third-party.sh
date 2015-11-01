#!/usr/bin/env bash

read -p "Install Dropbox?"                      INSTALL_DROPBOX
read -p "Install Oracle java?"      INSTALL_JAVA
read -p "Install numix?"            INSTALL_NUMIX
read -p "Install suckless-tools?"   INSTALL_SUCKLESS


case $INSTALL_DROPBOX in
    y|Y)
        sudo apt-get install python-gtk2
        wget -O tempfile https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.02.12_amd64.deb
        sudo dpkg -i tempfile
        dropbox start -i
        rm tempfile ;;
esac


case $INSTALL_JAVA in
    y|Y)
        sudo add-apt-repository ppa:webupd8team/java -y
        sudo apt-get update
        sudo apt-get install oracle-java8-installer --yes
        ;;
esac


case $INSTALL_NUMIX in
    y|Y)
        sudo add-apt-repository ppa:numix/ppa -y
        sudo apt-get update
        sudo apt-get install numix-gtk-theme numix-icon-theme-circle -y
        ;;
esac


case $INSTALL_SUCKLESS in
    y|Y)
        sudo add-apt-repository ppa:minos-archive/main -y
        sudo apt-get update
        sudo apt-get install suckless-tools
        ;;
esac

