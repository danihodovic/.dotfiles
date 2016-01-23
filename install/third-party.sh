#!/usr/bin/env bash
set -e
set -u

read -p "Install chrome? "                     -n 1 -r      install_chrome
echo
read -p "Install node version manager (nvm)? " -n 1 -r      install_nvm
echo
read -p "Install Dropbox? "                    -n 1 -r      install_dropbox
echo
read -p "Install numix? "                      -n 1 -r      install_numix
echo
read -p "Install Oracle Java? "                -n 1 -r      install_java
echo
read -p "Install apt-fast?"                    -n 1 -r      install_apt_fast
echo

case $install_apt_fast in
  y)
    sudo add-apt-repository -y ppa:saiarcot895/myppa
    sudo apt-get update
    sudo apt-get -y install apt-fast
    ;;
esac

case $install_nvm in
    y)
        set +e
        hash nvm
        nvm_installed=$?
        set -e
        if [ $nvm_installed = 1 ]; then
          git clone https://github.com/creationix/nvm.git ~/.nvm
          read -p "Install latest node and set as stable?" INSTALL_NODE
          case $INSTALL_NODE in
              y)
                  source ~/.nvm/nvm.sh
                  nvm install node
                  nvm alias default node
          esac
        else
            echo "Nvm already installed"
        fi
esac

case $install_chrome in
    y)
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
        sudo apt-get update
        sudo apt-get install -y google-chrome-beta
esac

case $install_dropbox in
    y)
        sudo apt-get install -y python-gtk2
        wget -O tempfile https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.02.12_amd64.deb
        sudo dpkg -i tempfile
        dropbox start -i
        rm tempfile ;;
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

