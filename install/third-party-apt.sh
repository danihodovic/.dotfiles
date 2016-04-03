#!/usr/bin/env bash
set -e
set -u

read -p "Install chrome? "                     -n 1 -r      install_chrome
echo
read -p "Install Oracle Java? "                -n 1 -r      install_java
echo
read -p "Install apt-fast?"                    -n 1 -r      install_apt_fast
echo
read -p "Install Dropbox? "                    -n 1 -r      install_dropbox
echo
read -p "Install numix? "                      -n 1 -r      install_numix
echo

case $install_apt_fast in
  y)
    sudo add-apt-repository -y ppa:saiarcot895/myppa
    sudo apt-get update
    sudo apt-get -y install apt-fast
    ;;
esac
case $install_chrome in
    y)
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
        sudo apt-get update
        sudo apt-get install -y google-chrome-beta
esac


case $install_java in
    y)
        sudo add-apt-repository ppa:webupd8team/java -y
        sudo apt-get update
        sudo apt-get install oracle-java8-installer --yes
        ;;
esac


case $install_numix in
    y)
        sudo add-apt-repository ppa:numix/ppa -y
        sudo apt-get update
        sudo apt-get install numix-gtk-theme numix-icon-theme-circle -y
        ;;
esac


case $install_dropbox in
    y)
        sudo apt-get install -y python-gtk2
        wget -O /tmp/tempfile https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.02.12_amd64.deb
        sudo dpkg -i /tmp/tempfile
        dropbox start -i
        rm /tmp/tempfile ;;
esac
