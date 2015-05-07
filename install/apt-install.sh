read -p "Install Dropbox?"          INSTALL_DROPBOX
read -p "Install Chromium?"         INSTALL_CHROME
read -p "Install Oracle java?"      INSTALL_JAVA
read -p "Install python+pip?"       INSTALL_PYTHON
read -p "Install suckless-tools?"   INSTALL_SUCKLESS

sudo apt-get install xbindkeys -y
sudo apt-get install cmake -y
sudo apt-get install python-dev -y
sudo apt-get install sshfs -y
sudo apt-get install tmux -y

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

case $INSTALL_SUCKLESS in
    y|Y)
        sudo add-apt-repository ppa:chilicuil/sucklesstools -y
        sudo apt-get update
        sudo apt-get install suckless-tools
        ;;
esac


# apt-get update && apt-get dist-upgrade

