read -p "Install Dropbox?"          INSTALL_DROPBOX
read -p "Install Chromium?"         INSTALL_CHROME
read -p "Install Oracle java?"      INSTALL_JAVA
read -p "Install python+pip?"       INSTALL_PYTHON
read -p "Install suckless-tools?"   INSTALL_SUCKLESS
read -p "Install bro?"              INSTALL_BRO
read -p "Install howdoi?"           INSTALL_HOWDOI
read -p "Install commandlinefu?"    INSTALL_CLF
read -p "Install numix?"            INSTALL_NUMIX

sudo apt-get update
sudo apt-get install xbindkeys -y
sudo apt-get install cmake -y
sudo apt-get install python-dev -y
sudo apt-get install sshfs -y
sudo apt-get install tmux -y
sudo apt-get install curl -y
sudo apt-get install git-extras -y

# Move to next monitor scripts
sudo apt-get install xdotool wmctrl -y


case $INSTALL_DROPBOX in
    y|Y)
        sudo apt-get install python-gtk2
        wget -O tempfile https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.02.12_amd64.deb
        sudo dpkg -i tempfile
        dropbox start -i
        rm tempfile ;;
esac


case $INSTALL_CHROME in
    y|Y) sudo apt-get install chromium-browser -y ;;
esac


case $INSTALL_JAVA in
    y|Y)
        sudo add-apt-repository ppa:webupd8team/java -y
        sudo apt-get update
        sudo apt-get install oracle-java8-installer --yes
        ;;
esac


case $INSTALL_PYTHON in
    y|Y)
        sudo apt-get install python -y
        sudo wget -O - https://bootstrap.pypa.io/get-pip.py | python
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


case $INSTALL_BRO in
    y|Y)
        sudo apt-get install ruby ruby-dev -y
        sudo gem install bropages
        ;;
esac


case $INSTALL_CLF in
    y|Y)
        sudo pip install clf
        ;;
esac


case $INSTALL_HOWDOI in
    y|Y)
        sudo apt-get install libxml2-dev libxslt1-dev
        sudo pip install howdoi
        ;;
esac
